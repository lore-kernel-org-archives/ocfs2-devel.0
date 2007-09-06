From: paul vogel <paulv@dds.nl>
Date: Thu Sep  6 10:20:25 2007
Subject: [Ocfs2-devel] 60% full and writes fail.. 
Message-ID: <0755BDB0-293F-4B70-A08E-E8DF24954C21@dds.nl>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


I have a setup with lot's of small files (Maildir), in 4 different  
volumes and for some
reason the volumes are full when they reach 60% usage (as reported by  
df ).

This was ofcourse a bit of a supprise for me .. lots of failed  
writes, bounced messages
and very angry customers.

Has anybody on this list seen this before (not the angry customers ;-) ?

Regards,

=paulv




# echo "ls -l //" | debugfs.ocfs2 /dev/drbd6
debugfs.ocfs2 1.2.1
debugfs:        34              drwxr-xr-x   6     0     0             
4096 16-Aug-2007 22:01 .
         34              drwxr-xr-x   6     0     0            4096  
16-Aug-2007 22:01 ..
         35              -rw-r--r--   1     0     0               0  
16-Aug-2007 22:01 bad_blocks
         36              -rw-r--r--   1     0     0          851968  
16-Aug-2007 22:01 global_inode_alloc
         37              -rw-r--r--   1     0     0           65536  
16-Aug-2007 22:01 slot_map
         38              -rw-r--r--   1     0     0         1048576  
16-Aug-2007 22:01 heartbeat
         39              -rw-r--r--   1     0     0    249999654912  
16-Aug-2007 22:01 global_bitmap
         40              drwxr-xr-x   2     0     0            4096   
6-Sep-2007 19:13 orphan_dir:0000
         41              drwxr-xr-x   2     0     0           16384   
6-Sep-2007 09:34 orphan_dir:0001
         42              drwxr-xr-x   2     0     0            4096  
16-Aug-2007 22:01 orphan_dir:0002
         43              drwxr-xr-x   2     0     0            4096  
16-Aug-2007 22:01 orphan_dir:0003
         44              -rw-r--r--   1     0     0         4194304  
16-Aug-2007 22:01 extent_alloc:0000
         45              -rw-r--r--   1     0     0               0  
16-Aug-2007 22:01 extent_alloc:0001
         46              -rw-r--r--   1     0     0               0  
16-Aug-2007 22:01 extent_alloc:0002
         47              -rw-r--r--   1     0     0               0  
16-Aug-2007 22:01 extent_alloc:0003
         48              -rw-r--r--   1     0     0       142606336  
16-Aug-2007 22:01 inode_alloc:0000
         49              -rw-r--r--   1     0     0      6966738944  
16-Aug-2007 22:01 inode_alloc:0001
         50              -rw-r--r--   1     0     0               0  
16-Aug-2007 22:01 inode_alloc:0002
         51              -rw-r--r--   1     0     0               0  
16-Aug-2007 22:01 inode_alloc:0003
         52              -rw-r--r--   1     0     0       268435456  
16-Aug-2007 22:01 journal:0000
         53              -rw-r--r--   1     0     0       268435456  
16-Aug-2007 22:02 journal:0001
         54              -rw-r--r--   1     0     0       268435456  
16-Aug-2007 22:02 journal:0002
         55              -rw-r--r--   1     0     0       268435456  
16-Aug-2007 22:03 journal:0003
         56              -rw-r--r--   1     0     0               0  
16-Aug-2007 22:01 local_alloc:0000
         57              -rw-r--r--   1     0     0               0  
16-Aug-2007 22:01 local_alloc:0001
         58              -rw-r--r--   1     0     0               0  
16-Aug-2007 22:01 local_alloc:0002
         59              -rw-r--r--   1     0     0               0  
16-Aug-2007 22:01 local_alloc:0003
         60              -rw-r--r--   1     0     0               0  
16-Aug-2007 22:01 truncate_log:0000
         61              -rw-r--r--   1     0     0               0  
16-Aug-2007 22:01 truncate_log:0001
         62              -rw-r--r--   1     0     0               0  
16-Aug-2007 22:01 truncate_log:0002
         63              -rw-r--r--   1     0     0               0  
16-Aug-2007 22:01 truncate_log:0003
debugfs:



My custer.conf :


cluster:
         node_count = 2
         name = pool_5
node:
         ip_port = 1015
         ip_address = 10.17.178.132
         number = 1
         name = jaguar
         cluster = pool_5
node:
         ip_port = 1015
         ip_address = 10.17.178.133
         number = 2
         name = joon
         cluster = pool_5


cluster:
         node_count = 2
         name = pool_6
node:
         ip_port = 1016
         ip_address = 10.17.178.132
         number = 3
         name = jaguar
         cluster = pool_6
node:
         ip_port = 1016
         ip_address = 10.17.178.133
         number = 4
         name = joon
         cluster = pool_6


cluster:
         node_count = 2
         name = pool_7
node:
         ip_port = 1017
         ip_address = 10.17.178.132
         number = 5
         name = jaguar
         cluster = pool_7
node:
         ip_port = 1017
         ip_address = 10.17.178.133
         number = 6
         name = joon
         cluster = pool_7


cluster:
         node_count = 2
         name = pool_8
node:
         ip_port = 1018
         ip_address = 10.17.178.132
         number = 7
         name = jaguar
         cluster = pool_8
node:
         ip_port = 1018
         ip_address = 10.17.178.133
         number = 8
         name = joon
         cluster = pool_8
