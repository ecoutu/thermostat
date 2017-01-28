defmodule Thermostat.RegistryTest do
  use ExUnit.Case, async: true

  setup context do
    {:ok, _} = Thermostat.Registry.start_link(context.test)
    {:ok, registry: context.test}
  end

  test "spawns buckets", %{registry: registry} do
    assert Thermostat.Registry.lookup(registry, "shopping") == :error

    Thermostat.Registry.create(registry, "shopping")
    assert {:ok, bucket} = Thermostat.Registry.lookup(registry, "shopping")

    Thermostat.Bucket.put(bucket, "milk", 1)
    assert Thermostat.Bucket.get(bucket, "milk") == 1
  end

  test "removes buckets on exit", %{registry: registry} do
    Thermostat.Registry.create(registry, "shopping")
    {:ok, bucket} = Thermostat.Registry.lookup(registry, "shopping")
    Agent.stop(bucket)

    # Do a call to ensure the registry processed the DOWN message
    _ = Thermostat.Registry.create(registry, "bogus")
    assert Thermostat.Registry.lookup(registry, "shopping") == :error
  end

  test "removes bucket on crash", %{registry: registry} do
    Thermostat.Registry.create(registry, "shopping")
    {:ok, bucket} = Thermostat.Registry.lookup(registry, "shopping")

    # Kill the bucket and wait for the notification
    Process.exit(bucket, :shutdown)

    # Wait until the bucket is dead
    ref = Process.monitor(bucket)
    assert_receive {:DOWN, ^ref, _, _, _}

    # Do a call to ensure the registry processed the DOWN message
    _ = Thermostat.Registry.create(registry, "bogus")
    assert Thermostat.Registry.lookup(registry, "shopping") == :error
  end
end
