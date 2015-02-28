#!/bin/sh

#Copy the RPMs out and back to the shared folder
sudo rsync --no-relative -vahu /root/rpmbuild/RPMS/* /vagrant
