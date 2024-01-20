resource "aws_autoscaling_group" "demo-monish" {
  name                      = "demo-monish-ASG-terra"
  max_size                  = 5
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 2
  force_delete              = true
  launch_template {
        id = aws_launch_template.demo-monish.id
        version = aws_launch_template.demo-monish.latest_version
  }
  vpc_zone_identifier      = aws_subnet.demo-monish-public-subnets.*.id
  tag {
    key                 = "Name"
    value               = "demo-monish-ASG"
    propagate_at_launch = false    
  }
}

# data "aws_instances" "demo-monish" {
#   instance_tags = {
#     aws:autoscaling:groupName	 = "demo-monish-ASG-terra"
#   }
#   instance_state_names = ["running"]
# }


data "aws_instances" "demo-monish" {
  filter {
    name   = "tag:aws:autoscaling:groupName"
    values = ["demo-monish-ASG-terra"]
  }
}


resource "aws_cloudwatch_metric_alarm" "demo-monish" {
  alarm_name          = "demo-monish-terra"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "ec2_load_percentage"
  namespace           = "ServerLoad"
  period              = 300
  statistic           = "Maximum"
  threshold           = 75
  dimensions = {
    Instance  = "i-0e5a867293a6df040"
    AutoScalingGroupName = aws_autoscaling_group.demo-monish.name 
  }
  alarm_description = "This metric monitors ec2  Load average"
  alarm_actions     = [aws_autoscaling_policy.bat.arn]
}


resource "aws_autoscaling_policy" "bat" {
  name                   = "foobar3-terraform-test"
  scaling_adjustment     = 4
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.demo-monish.name
}