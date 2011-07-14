From: r.giordani at libero.it <r.giordani@libero.it>
Date: Thu, 14 Jul 2011 09:47:01 +0200 (CEST)
Subject: [Ocfs2-devel] mount.ocfs2: Invalid argument while mounting
 /dev/mapper/xenconfig_part1 on /etc/xen/vm/. Check 'dmesg' for more
 information on this error.
Message-ID: <21380793.3350871310629621222.JavaMail.defaultUser@defaultHost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello,
this is my scenario:
1)I've created a Pacemaker cluster with the following ocfs package on opensuse 
11.3 64bit
ocfs2console-1.8.0-2.1.x86_64
ocfs2-tools-o2cb-1.8.0-2.1.x86_64
ocfs2-tools-1.8.0-2.1.x86_64

2)I've configured the cluster as usual :
<resources>
      <clone id="dlm-clone">
        <meta_attributes id="dlm-clone-meta_attributes">
          <nvpair id="dlm-clone-meta_attributes-interleave" name="interleave" 
value="true"/>
        </meta_attributes>
        <primitive class="ocf" id="dlm" provider="pacemaker" type="controld">
          <operations>
            <op id="dlm-monitor-120s" interval="120s" name="monitor"/>
          </operations>
        </primitive>
      </clone>
      <clone id="o2cb-clone">
        <meta_attributes id="o2cb-clone-meta_attributes">
          <nvpair id="o2cb-clone-meta_attributes-interleave" name="interleave" 
value="true"/>
        </meta_attributes>
        <primitive class="ocf" id="o2cb" provider="ocfs2" type="o2cb">
          <operations>
            <op id="o2cb-monitor-120s" interval="120s" name="monitor"/>
          </operations>
        </primitive>
      </clone>
      <clone id="XenConfigClone">
        <primitive class="ocf" id="XenConfig" provider="heartbeat" type="
Filesystem">
          <meta_attributes id="XenConfig-meta_attributes">
            <nvpair id="XenConfig-meta_attributes-is-managed" name="is-
managed" value="true"/>
            <nvpair id="XenConfig-meta_attributes-target-role" name="target-
role" value="Started"/>
          </meta_attributes>
          <operations id="XenConfig-operations">
            <op id="XenConfig-op-monitor-120" interval="120" name="monitor"/>
          </operations>
          <instance_attributes id="XenConfig-instance_attributes">
            <nvpair id="XenConfig-instance_attributes-device" name="device" 
value="/dev/mapper/xenconfig_part1"/>
            <nvpair id="XenConfig-instance_attributes-directory" name="
directory" value="/etc/xen/vm"/>
            <nvpair id="XenConfig-instance_attributes-fstype" name="fstype" 
value="ocfs2"/>
          </instance_attributes>
        </primitive>
        <meta_attributes id="XenConfigClone-meta_attributes">
          <nvpair id="XenConfigClone-meta_attributes-target-role" name="target-
role" value="Started"/>
          <nvpair id="XenConfigClone-meta_attributes-interleave" name="
interleave" value="true"/>
          <nvpair id="XenConfigClone-meta_attributes-ordered" name="ordered" 
value="true"/>
        </meta_attributes>
      </clone>
      <clone id="XenImagesClone">
        <primitive class="ocf" id="XenImages" provider="heartbeat" type="
Filesystem">
          <meta_attributes id="XenImages-meta_attributes">
            <nvpair id="XenImages-meta_attributes-is-managed" name="is-
managed" value="true"/>
          </meta_attributes>
          <operations id="XenImages-operations">
            <op id="XenImages-op-monitor-120" interval="120" name="monitor"/>
          </operations>
          <instance_attributes id="XenImages-instance_attributes">
            <nvpair id="XenImages-instance_attributes-device" name="device" 
value="/dev/mapper/xenimages_part1"/>
            <nvpair id="XenImages-instance_attributes-directory" name="
directory" value="/var/lib/xen/images"/>
            <nvpair id="XenImages-instance_attributes-fstype" name="fstype" 
value="ocfs2"/>
          </instance_attributes>
        </primitive>
        <meta_attributes id="XenImagesClone-meta_attributes">
          <nvpair id="XenImagesClone-meta_attributes-target-role" name="target-
role" value="Started"/>
          <nvpair id="XenImagesClone-meta_attributes-interleave" name="
interleave" value="true"/>
          <nvpair id="XenImagesClone-meta_attributes-ordered" name="ordered" 
value="true"/>
        </meta_attributes>
      </clone>
</resources>

And all the resource are up and running

3)Then, using my SAN, I've configured multipath as following:

xenconfig (3600a0b8000754c84000002a04e031e5a) dm-0 IBM,1726-4xx  FAStT
size=19G features='1 queue_if_no_path' hwhandler='1 rdac' wp=rw
|-+- policy='round-robin 0' prio=3 status=active
| |- 3:0:1:0 sdd 8:48  active ready running
| `- 4:0:1:0 sdh 8:112 active ready running
`-+- policy='round-robin 0' prio=0 status=enabled
  |- 3:0:0:0 sdb 8:16  active ghost running
  `- 4:0:0:0 sdf 8:80  active ghost running
xenimages (3600a0b8000754ce3000003024e031dbf) dm-1 IBM,1726-4xx  FAStT
size=400G features='1 queue_if_no_path' hwhandler='1 rdac' wp=rw
|-+- policy='round-robin 0' prio=3 status=active
| |- 3:0:0:1 sdc 8:32  active ready running
| `- 4:0:0:1 sdg 8:96  active ready running
`-+- policy='round-robin 0' prio=0 status=enabled
  |- 3:0:1:1 sde 8:64  active ghost running
  `- 4:0:1:1 sdi 8:128 active ghost running

4)Then I've create the first partition on /dev/mapper/xenconfig.

5)format the partition as ocfs2
mkfs.ocfs2 -F /dev/mapper/xenconfig_part1
mkfs.ocfs2 1.8.0
Cluster stack: pcmk
Cluster name: pacemaker
Stack Flags: 0x0
NOTE: Feature extended slot map may be enabled
Label:
Features: sparse extended-slotmap backup-super unwritten inline-data strict-
journal-super xattr indexed-dirs refcount discontig-bg
Block size: 4096 (12 bits)
Cluster size: 4096 (12 bits)
Volume size: 20063436800 (4898300 clusters) (4898300 blocks)
Cluster groups: 152 (tail covers 27644 clusters, rest cover 32256 clusters)
Extent allocator size: 4194304 (1 groups)
Journal size: 125394944
Node slots: 8
Creating bitmaps: done
Initializing superblock: done
Writing system files: done
Writing superblock: done
Writing backup superblock: 3 block(s)
Formatting Journals: done
Growing extent allocator: done
Formatting slot map: done
Formatting quota files: done
Writing lost+found: done
mkfs.ocfs2 successful

6)this is the /etc/sysconfig/o2cb file
#
# This is a configuration file for automatic startup of the O2CB
# driver.  It is generated by running /etc/init.d/o2cb configure.
# On Debian based systems the preferred method is running
# 'dpkg-reconfigure ocfs2-tools'.
#

# O2CB_ENABLED: 'true' means to load the driver on boot.
O2CB_ENABLED=true

# O2CB_STACK: The name of the cluster stack backing O2CB.
O2CB_STACK=pcmk

# O2CB_BOOTCLUSTER: If not empty, the name of a cluster to start.
O2CB_BOOTCLUSTER=pacemaker

# O2CB_HEARTBEAT_THRESHOLD: Iterations before a node is considered dead.
O2CB_HEARTBEAT_THRESHOLD=

# O2CB_IDLE_TIMEOUT_MS: Time in ms before a network connection is considered 
dead.
O2CB_IDLE_TIMEOUT_MS=

# O2CB_KEEPALIVE_DELAY_MS: Max time in ms before a keepalive packet is sent
O2CB_KEEPALIVE_DELAY_MS=

# O2CB_RECONNECT_DELAY_MS: Min time in ms between connection attempts
O2CB_RECONNECT_DELAY_MS=


7)nodo5:~ # mount /dev/mapper/xenconfig_part1 /etc/xen/vm/
mount.ocfs2: Invalid argument while mounting /dev/mapper/xenconfig_part1 on 
/etc/xen/vm/. Check 'dmesg' for more information on this error.
 and this is the log messages

Jul 14 09:28:36 nodo5 ocfs2_controld: new client connection 5
Jul 14 09:28:36 nodo5 ocfs2_controld: client msg
Jul 14 09:28:36 nodo5 ocfs2_controld: client message 0 from 5: MOUNT
Jul 14 09:28:36 nodo5 ocfs2_controld: start_mount: uuid 
"5E40DA55CC534CB7AF9A2D402C9BCCF0", device "/dev/mapper/xenconfig_part1", 
service "ocfs2"
Jul 14 09:28:36 nodo5 ocfs2_controld: Adding service "ocfs2" to device 
"/dev/mapper/xenconfig_part1" uuid "5E40DA55CC534CB7AF9A2D402C9BCCF0"
Jul 14 09:28:36 nodo5 ocfs2_controld: Starting join for group "ocfs2:
5E40DA55CC534CB7AF9A2D402C9BCCF0"
Jul 14 09:28:36 nodo5 ocfs2_controld: cpg_join succeeded
Jul 14 09:28:36 nodo5 ocfs2_controld: start_mount returns 0
Jul 14 09:28:36 nodo5 ocfs2_controld: confchg called
Jul 14 09:28:36 nodo5 ocfs2_controld: group "ocfs2:
5E40DA55CC534CB7AF9A2D402C9BCCF0" confchg: members 1, left 0, joined 1
Jul 14 09:28:36 nodo5 ocfs2_controld: Node 1761913024 joins group ocfs2:
5E40DA55CC534CB7AF9A2D402C9BCCF0
Jul 14 09:28:36 nodo5 ocfs2_controld: This node joins group ocfs2:
5E40DA55CC534CB7AF9A2D402C9BCCF0
Jul 14 09:28:36 nodo5 ocfs2_controld: Filling node 1761913024 to group ocfs2:
5E40DA55CC534CB7AF9A2D402C9BCCF0
Jul 14 09:28:36 nodo5 ocfs2_controld: Registering mountgroup 
5E40DA55CC534CB7AF9A2D402C9BCCF0 with dlm_controld
Jul 14 09:28:36 nodo5 ocfs2_controld: Registering 
"5E40DA55CC534CB7AF9A2D402C9BCCF0" with dlm_controld
Jul 14 09:28:36 nodo5 ocfs2_controld: message from dlmcontrol
Jul 14 09:28:36 nodo5 ocfs2_controld: Registration of 
"5E40DA55CC534CB7AF9A2D402C9BCCF0" complete
Jul 14 09:28:36 nodo5 ocfs2_controld: Mountgroup 
5E40DA55CC534CB7AF9A2D402C9BCCF0 successfully registered with dlm_controld
Jul 14 09:28:36 nodo5 ocfs2_controld: notify_mount_client sending 0 "OK"
Jul 14 09:28:36 nodo5 ocfs2_controld: Notified client: 1
Jul 14 09:28:36 nodo5 ocfs2_controld: client msg
Jul 14 09:28:36 nodo5 ocfs2_controld: client message 1 from 5: MRESULT
Jul 14 09:28:36 nodo5 ocfs2_controld: complete_mount: uuid 
"5E40DA55CC534CB7AF9A2D402C9BCCF0", errcode "22", service "ocfs2"
Jul 14 09:28:36 nodo5 ocfs2_controld: Unregistering mountgroup 
5E40DA55CC534CB7AF9A2D402C9BCCF0
Jul 14 09:28:36 nodo5 ocfs2_controld: Unregistering 
"5E40DA55CC534CB7AF9A2D402C9BCCF0" from dlm_controld
Jul 14 09:28:36 nodo5 ocfs2_controld: time to leave group 
5E40DA55CC534CB7AF9A2D402C9BCCF0
Jul 14 09:28:36 nodo5 ocfs2_controld: calling LEAVE for group 
5E40DA55CC534CB7AF9A2D402C9BCCF0
Jul 14 09:28:36 nodo5 ocfs2_controld: leaving group "ocfs2:
5E40DA55CC534CB7AF9A2D402C9BCCF0"
Jul 14 09:28:36 nodo5 ocfs2_controld: cpg_leave succeeded
Jul 14 09:28:36 nodo5 ocfs2_controld: confchg called
Jul 14 09:28:36 nodo5 ocfs2_controld: group "ocfs2:
5E40DA55CC534CB7AF9A2D402C9BCCF0" confchg: members 0, left 1, joined 0
Jul 14 09:28:36 nodo5 ocfs2_controld: Node 1761913024 leaves group ocfs2:
5E40DA55CC534CB7AF9A2D402C9BCCF0
Jul 14 09:28:36 nodo5 ocfs2_controld: notify_mount_client sending 0 "OK"
Jul 14 09:28:36 nodo5 ocfs2_controld: Notified client: 1
Jul 14 09:28:36 nodo5 ocfs2_controld: client 6 fd 15 dead
Jul 14 09:28:36 nodo5 ocfs2_controld: client msg
Jul 14 09:28:36 nodo5 ocfs2_controld: client 5 fd 14 dead
Jul 14 09:28:36 nodo5 ocfs2_controld: client 5 fd -1 dead
Jul 14 09:28:36 nodo5 kernel: [52007.749756] (mount.ocfs2,7720,4):
ocfs2_initialize_super:2119 ERROR: couldn't mount because of unsupported 
optional features (2000).
Jul 14 09:28:36 nodo5 kernel: [52007.749761] (mount.ocfs2,7720,4):
ocfs2_fill_super:1021 ERROR: status = -22
Jul 14 09:28:36 nodo5 kernel: [52007.749770] ocfs2: Unmounting device (253,2) 
on (node 0)

Could someone explain why?
I've made the same thing with ocfs2-1.4 and all works fine

Regards,
Roberto.
