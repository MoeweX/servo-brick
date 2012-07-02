#!/usr/bin/env ruby
# -*- ruby encoding: utf-8 -*-

require 'tinkerforge/ip_connection'
require 'tinkerforge/brick_servo'

include Tinkerforge

HOST = 'localhost'
PORT = 4223
UID = '9oTxLQ3d46C' # Change to your UID

ipcon = IPConnection.new HOST, PORT # Create IP connection to brickd
servo = BrickServo.new UID # Create device object
ipcon.add_device servo # Add device to IP connection
# Don't use device before it is added to a connection

# Use position reached callback to swing back and forth
servo.register_callback(BrickServo::CALLBACK_POSITION_REACHED) do |servo_num, position|
  if position == 9000
    puts 'Position: 90°, going to -90°'
    servo.set_position servo_num, -9000
  elsif position == -9000
    puts 'Position: -90°, going to 90°'
    servo.set_position servo_num, 9000
  else
    puts 'Error' # Can only happen if another program sets position
  end
end

# Set velocity to 100°/s. This has to be smaller or equal to
# maximum velocity of the servo, otherwise cb_reached will be
# called too early
servo.set_velocity 0, 10000
servo.set_position 0, 9000
servo.enable 0

puts 'Press key to exit'
$stdin.gets
ipcon.destroy