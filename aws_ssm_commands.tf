//data "aws_instances" "nodes" {
//  instance_tags = {
//    Moniroting = "true"
//  }
//  instance_state_names = ["running"]
//}

data "template_file" "install_metricbeat_ansible_playbook" {
  template = file("${path.module}/ansible/install_metricbeat.yml")

}

resource "aws_ssm_association" "install_metricbeat_ansible_playbook" {
  name             = "AWS-RunAnsiblePlaybook"
  association_name = "install_metricbeat_ansible_playbook"

  schedule_expression = "rate(30 minutes)"

  targets {
    key    = "tag:Moniroting"
    values = ["true"]
  }

  parameters = {
    playbook = data.template_file.install_metricbeat_ansible_playbook.rendered
  }

  output_location {
    s3_bucket_name = "ssm-commands-eu-west-2-637085696726"
    s3_key_prefix  = "logs"
  }
}
