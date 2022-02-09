const std = @import("std");

const Allocator = std.mem.Allocator;

const vulkan = @import("./vulkan.zig");
const vk = @import("./vk.zig");

const QueueFamilies = @This();

graphics: ?u32 = null,

pub fn isComplete(queue_families: QueueFamilies) bool {
    return queue_families.graphics != null;
}

pub fn findRaw(instance: *vulkan.Instance, physical_device: vk.PhysicalDevice) !QueueFamilies {
    var queue_families_len: u32 = undefined;
    instance.vki.getPhysicalDeviceQueueFamilyProperties(physical_device, &queue_families_len, null);

    var queue_families = try instance.allocator.alloc(vk.QueueFamilyProperties, queue_families_len);
    defer instance.allocator.free(queue_families);
    instance.vki.getPhysicalDeviceQueueFamilyProperties(physical_device, &queue_families_len, queue_families.ptr);

    var families = QueueFamilies{};

    var i: u32 = 0;
    while (i < queue_families_len) : (i += 1) {
        const queue_family = queue_families[i];

        if (queue_family.queue_flags.graphics_bit) {
            families.graphics = i;
        }
    }

    return families;
}

pub fn find(adapter: *vulkan.Adapter) !QueueFamilies {
    var instance = @fieldParentPtr(vulkan.Instance, "super", adapter.super.instance);
    var physical_device = adapter.handle;

    return findRaw(instance, physical_device);
}
