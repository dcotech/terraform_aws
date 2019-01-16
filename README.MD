This repo is to use Terraform to manage AWS resources: from making VPC, to creating S3 buckets, and deploying EC2 resources.

Much of this code is based off LinuxAcademy's Course titled `"Managing Applications and Infrastructure with Terraform"` (https://linuxacademy.com/devops/training/course/name/managing-applications-and-infrastructure-with-terraform)

However, I'm assuming the user may have experience with AWS, but not much experience with Terraform. I've added comments almost everywhere to help further explain concepts. I've also commited consistently to make it easy to follow the build history and how a person logically progresses when writing Terraform plans for AWS environments.

I highly recommended using an IDE such as Visual Studio, Atom, or Sublime. This is because, when working with many files with Terraform, the variables namespaces can get unwiedly at times (Trying to remember which variables goes where is an absolute pain. It also reduces your typos)

Thanks goes out again to LinuxAcademy for the course and source code.