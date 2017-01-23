defmodule Thermostat.BucketTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, bucket} = Thermostat.Bucket.start_link
    {:ok, bucket: bucket}
  end

  test "stores values by key", %{bucket: bucket} do
    assert Thermostat.Bucket.get(bucket, "milk") == nil

    Thermostat.Bucket.put(bucket, "milk", 3)
    assert Thermostat.Bucket.get(bucket, "milk") == 3
  end
end
