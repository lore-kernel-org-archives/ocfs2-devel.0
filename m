From: Zhen Ren <zren@suse.com>
Date: Tue, 31 Mar 2015 21:44:59 -0600
Subject: [Ocfs2-devel] [ISSUE] mount fail by using "LABEL=" parameter
Message-ID: <551C046B020000D400069E3F@relay2.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi all,

In my 3-nodes(n1,n2,n3) cluster, mount always fail by using "LABEL=" parameter, except for the node(n1) I mkfs.ocfs2 on.
To make it easy to talk, call n1 local node, and call n2 and n3 remote nodes.

After mkfs.ocfs2 on n1, it's ok to mount by "LABEL=" options on n1.
But when doing the same on remote nodes, it complaints this msg:

"mount: can't find LABEL=multi-write_append_truncate-test".

However, when debugfs.ocfs2 -> open /dev/sdb1 -> stats, you can actually see this LABEL.
But using devicename in place of LABEL, mount can succeed.

I encounterd this issue when I run ocfs2 testsuites on multi-nodes. It always interrupt test.

If more info or helps needed,please feel free to  tell me.

-------------
Reproduce steps:

1.setup cluster environment
   n1:~ # crm configure show
```
node 318951192: n3
node 318951194: n2
node 318951229: n1
primitive p_dlm ocf:pacemaker:controld \
        op monitor interval=60 timeout=60 \
        meta target-role=Started
primitive p_o2cb ocf:ocfs2:o2cb \
        op monitor interval=60 timeout=60 \
        meta target-role=Started
primitive p_ocfs2 Filesystem \
        params device="/dev/sdb1" directory="/mnt/shared" fstype=ocfs2 options=acl \
        op monitor interval=60 timeout=60 \
        meta target-role=Stopped
primitive p_stonith_sbd stonith:external/sbd \
        params sbd_device="/dev/sdc1" \
        meta target-role=Started
group g_base p_dlm p_o2cb
clone cl_base g_base \
        meta interleave=true
property cib-bootstrap-options: \
        dc-version=1.1.12-1.1.12.git20140904.266d5c2 \
        cluster-infrastructure=corosync \
        cluster-name=cluster \
        last-lrm-refresh=1422851544

```

2.mkfs on n1, and mount succeed by "LABEL" options
n1:~ # /usr/bin/sudo -u root /sbin/mkfs.ocfs2 --fs-features=sparse,unwritten,inline-data --cluster-stack=pcmk --cluster-name=cluster -b 512 -C 4096 -L multi-write_append_truncate-test -N 3 -F /dev/sdb1
```
mkfs.ocfs2 1.8.2
On disk cluster (pcmk,hacluster,0) does not match the active cluster (pcmk,cluster,0).
mkfs.ocfs2 will not be able to determine if this operation can be done safely.
Format is forced.
Cluster stack: pcmk
Cluster name: cluster
Stack Flags: 0x0
NOTE: Feature extended slot map may be enabled
Overwriting existing ocfs2 partition.
WARNING: Cluster check disabled.
Proceed (y/N): y
Label: multi-write_append_truncate-test
Features: sparse extended-slotmap backup-super unwritten inline-data strict-journal-super xattr indexed-dirs refcount discontig-bg
Block size: 512 (9 bits)
Cluster size: 4096 (12 bits)
Volume size: 107372085248 (26213888 clusters) (209711104 blocks)
Cluster groups: 7315 (tail covers 512 clusters, rest cover 3584 clusters)
Extent allocator size: 36700160 (35 groups)
Journal size: 33554432
Node slots: 3
Creating bitmaps: done
Initializing superblock: done
Writing system files: done
Writing superblock: done
Writing backup superblock: 4 block(s)
Formatting Journals: done
Growing extent allocator: done
Formatting slot map: done
Formatting quota files: done
Writing lost+found: done
mkfs.ocfs2 successful
```
n1:~ # mount LABEL=multi-write_append_truncate-test /mnt/shared/
```
sdb      8:16   0  100G  0 disk 
??sdb1   8:17   0  100G  0 part /mnt/shared
```

3.mount on remote nodes, fails by using "LABEL", but can succeed by devicename.
* n2:~ # debugfs.ocfs2 
```
debugfs.ocfs2 1.8.2
debugfs: open /dev/sdb1
debugfs: stats
 Revision: 0.90
        Mount Count: 0   Max Mount Count: 20
        State: 0   Errors: 0
        Check Interval: 0   Last Check: Wed Apr  1 10:49:32 2015
        Creator OS: 0
        Feature Compat: 3 backup-super strict-journal-super
        Feature Incompat: 14288 sparse extended-slotmap userspace-stack inline-data xattr indexed-dirs refcount discontig-bg
        Tunefs Incomplete: 0 
        Feature RO compat: 1 unwritten
        Root Blknum: 17   System Dir Blknum: 18
        First Cluster Group Blknum: 8
        Block Size Bits: 9   Cluster Size Bits: 12
        Max Node Slots: 3
        Extended Attributes Inline Size: 256
        Label: multi-write_append_truncate-test
        UUID: A6302CB119494841A4651B7E2A7BB14B
        Hash: 1818001921 (0x6c5c8201)
        DX Seeds: 2197997288 2958161053 2740736257 (0x8302c6e8 0xb051f49d 0xa35c5101)
        Cluster stack: pcmk
        Cluster name: cluster
        Cluster flags: 0 
        Inode: 2   Mode: 00   Generation: 2664465793 (0x9ed08581)
        FS Generation: 2664465793 (0x9ed08581)
        CRC32: 00000000   ECC: 0000
        Type: Unknown   Attr: 0x0   Flags: Valid System Superblock 
        Dynamic Features: (0x0) 
        User: 0 (root)   Group: 0 (root)   Size: 0
        Links: 0   Clusters: 26213888
        ctime: 0x551b5cbc 0x0 -- Wed Apr  1 10:49:32.0 2015
        atime: 0x0 0x0 -- Thu Jan  1 08:00:00.0 1970
        mtime: 0x551b5cbc 0x0 -- Wed Apr  1 10:49:32.0 2015
        dtime: 0x0 -- Thu Jan  1 08:00:00 1970
        Refcount Block: 0
        Last Extblk: 0   Orphan Slot: 0
        Sub Alloc Slot: Global   Sub Alloc Bit: 65535
```

*n2:~ # mount LABEL=multi-write_append_truncate-test /mnt/shared/
```
mount: can't find LABEL=multi-write_append_truncate-test
```

*n2:~ # mount /dev/sdb1 /mnt/shared/
```
sdb      8:16   0  100G  0 disk 
??sdb1   8:17   0  100G  0 part /mnt/shared
```



--
Best regards,
Eric, Ren
HA team, SUSE
