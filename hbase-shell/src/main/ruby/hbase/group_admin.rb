#
# Copyright The Apache Software Foundation
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include Java
java_import org.apache.hadoop.hbase.util.Pair

# Wrapper for org.apache.hadoop.hbase.group.GroupAdminClient
# Which is an API to manage region server groups

module Hbase
  class GroupAdmin
    include HBaseConstants

    def initialize(connection, formatter)
      @admin = org.apache.hadoop.hbase.group.GroupAdmin.newClient(connection)
      @formatter = formatter
    end

    #----------------------------------------------------------------------------------------------
    # Returns a list of groups in hbase
    def listGroups
      @admin.listGroups.map { |g| g.getName }
    end
    #----------------------------------------------------------------------------------------------
    # get a group's information
    def getGroup(group_name)
      group = @admin.getGroupInfo(group_name)
      res = {}
      if block_given?
        yield("Servers:")
      else
        res += v
      end
      group.getServers.each do |v|
        if block_given?
          yield(v.toString)
        else
          res += v.toString
        end
      end
      if block_given?
        yield("Tables:")
      else
        res += v
      end
      group.getTables.each do |v|
        if block_given?
          yield(v.toString)
        else
          res += v.toString
        end
      end
    end
    #----------------------------------------------------------------------------------------------
    # add a group
    def addGroup(group_name)
      @admin.addGroup(group_name)
    end
    #----------------------------------------------------------------------------------------------
    # remove a group
    def removeGroup(group_name)
      @admin.removeGroup(group_name)
    end
    #----------------------------------------------------------------------------------------------
    # balance a group
    def balanceGroup(group_name)
      @admin.balanceGroup(group_name)
    end
    #----------------------------------------------------------------------------------------------
    # move server to a group
    def moveServers(dest, *args)
      servers = java.util.HashSet.new()
      args[0].each do |s|
        servers.add(com.google.common.net.HostAndPort.fromString(s))
      end
      @admin.moveServers(servers, dest)
    end
    #----------------------------------------------------------------------------------------------
    # move server to a group
    def moveTables(dest, *args)
      tables = java.util.HashSet.new();
      args[0].each do |s|
        tables.add(org.apache.hadoop.hbase.TableName.valueOf(s))
      end
      @admin.moveTables(tables,dest)
    end
    #----------------------------------------------------------------------------------------------
    # get group of server
    def getGroupOfServer(server)
      @admin.getGroupOfServer(com.google.common.net.HostAndPort.fromString(s))
    end
    #----------------------------------------------------------------------------------------------
    # get group of server
    def getGroupOfTable(table)
      @admin.getGroupInfoOfTable(com.google.common.net.HostAndPort.fromString(s))
    end
    #----------------------------------------------------------------------------------------------
    # get list tables of groups
    def listTablesOfGroup(group_name)
      @admin.listTablesOfGroup(group_name)
    end
  end
end