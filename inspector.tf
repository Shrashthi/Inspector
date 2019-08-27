## This will create resource group to help identify tags ##


resource "aws_inspector_resource_group" "resource1" {
  tags = {
    Name = "Redhat_linux"
  }
}

resource "aws_inspector_resource_group" "resource2" {
  tags = {
    Name = "Windows_2016"
}
}



## Create assessment target ##


resource "aws_inspector_assessment_target" "InspectortargetLinux" {
  name               = "Inspector-target-linux"
  resource_group_arn = "${aws_inspector_resource_group.resource1.arn}"
}

resource "aws_inspector_assessment_target" "InspectortargetWindows" {
  name               = "Inspector-target-Windows"
  resource_group_arn = "${aws_inspector_resource_group.resource2.arn}"
}


## Create assessment template ##


resource "aws_inspector_assessment_template" "Inspector-template-Linux" {

  name       = "Inspector-template-linux"

  target_arn = "${aws_inspector_assessment_target.InspectortargetLinux.arn}"

  duration   = 900

  rules_package_arns = [

    "arn:aws:inspector:us-east-1:316112463485:rulespackage/0-gEjTy7T7",

    "arn:aws:inspector:us-east-1:316112463485:rulespackage/0-PmNV0Tcd",

  ]

}

resource "aws_inspector_assessment_template" "Inspector-template-Windows" {

  name       = "Inspector-template-windows"

  target_arn = "${aws_inspector_assessment_target.InspectortargetWindows.arn}"

duration   = 900

  rules_package_arns = [

    "arn:aws:inspector:us-east-1:316112463485:rulespackage/0-gEjTy7T7",

    "arn:aws:inspector:us-east-1:316112463485:rulespackage/0-PmNV0Tcd",

  ]

}

resource "aws_cloudwatch_event_rule" "every_month" {
    name = "triggerrunoncemonth"
    description = "Fires once in a month"
    schedule_expression = "rate(5 minutes)"
}

resource "aws_cloudwatch_event_target" "check_inspector_windows" {
    rule = "${aws_cloudwatch_event_rule.every_month.name}"
    role_arn = "${aws_iam_role.inspector.arn}"
    arn = "${aws_inspector_assessment_template.Inspector-template-Windows.arn}"
}

resource "aws_cloudwatch_event_target" "check_inspector_linux" {
    rule = "${aws_cloudwatch_event_rule.every_month.name}"
    role_arn = "${aws_iam_role.inspector.arn}"
    arn = "${aws_inspector_assessment_template.Inspector-template-Linux.arn}"
}

