From: Changwei Ge <ge.changwei@h3c.com>
Date: Tue, 19 Sep 2017 03:32:16 +0000
Subject: [Ocfs2-devel] Mixed mounts w/ different physical block sizes
 (long post)
References: <f0c4daea-133b-d854-c17c-fd6fbbc427bf@rentapacs.de>
	<9e885fc1-5701-c985-f63f-b90767253328@rentapacs.de>
	<8370bcbe-0a70-46ac-3c69-aea24263f4c2@rentapacs.de>
Message-ID: <63ADC13FD55D6546B7DECE290D39E373CED50ACE@H3CMLB14-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Michael,

On 2017/9/18 23:45, Michael Ulbrich wrote:
> Hi again,
> 
> chatting with a helpful person on #ocfs2 IRC channel this morning  I got
> encouraged to cross-post to ocsf2-devel. For historic background and
> further details pls. see my two previous posts to ocfs2-users from last
> week which are unanswered so far.
> 
> According to my current state of inspection I changed the topic from
> 
> "Node 8 doesn't mount / Wrong slot map assignment" to the current "Mixed
> mounts ..."
> 
> Here we go:
> 
> I've learnt that large hard disks in increasing number come formatted w/
> 4k physical blocks size.
> 
> Now I've created an ocfs2 shared file system on top of drbd on a RAID1
> of two 6 TB disks with such 4k physical block size. File system creation
> was done on a hypervisor which actually saw the device as having 4k
> physical sector size.
> 
> I'm using the default o2cb cluster stack. Version is ocfs2 1.6.4 on
> stock Debian 8.
> 
> A node (numbered "1" in cluster.conf) which mounts this device with 4k
> phys. blocks leads to a strange "times 8" numbering when checking
> heartbeat debug info with 'echo "hb" | debugfs.ocfs2 -n /dev/drbd1':
> 
> hb
>          node: node              seq       generation checksum
>             8:    1 0000000059bfd253 00bfa1b63f30e494 c518c55a
> 
> I'm not sure why the first 2 columns are named "node:" and "node" but
> assume the first "node:" is an index into some internal data structure
> (slot map ?, heartbeat region ?) while the second "node" column shows
> the actual node number as given in cluster.conf
> 
> Now a second node mounts the shared file system again as 4k block device:
> 
> hb
>          node: node              seq       generation checksum
>             8:    1 0000000059bfd36a 00bfa1b63f30e494 d4f79d63
>            16:    2 0000000059bfd369 7acf8521da342228 4b8cd74d
> 
> As it actually happened in my setup of a two node cluster with 2
> hypervisors and  3 virtual machines on top of each (8 nodes in total),
> when mounting the fs on the first virtual machine with node number 3 we get:
> 
> hb
>          node: node              seq       generation checksum
>             3:    3 0000000059bfd413 59eb77b4db07884b 87a5057d
>             8:    1 0000000059bfd412 00bfa1b63f30e494 e782d86e
>            16:    2 0000000059bfd413 7acf8521da342228 cd48c018
> 
> Uhm, ... wait ... 3 ??
> 
> Mounting on further VMs (nodes 4, 5, 6 and 7) leads to:
> 
> hb
>          node: node              seq       generation checksum
>             3:    3 0000000059bfd413 59eb77b4db07884b 87a5057d
>             4:    4 0000000059bfd413 debf95d5ff50dc10 3839c791
>             5:    5 0000000059bfd414 529a98c758325d5b 60080c42
>             6:    6 0000000059bfd412 14acfb487fa8c8b8 f54cef9d
>             7:    7 0000000059bfd413 4d2d36de0b0d6b2e 3f1ad275
>             8:    1 0000000059bfd412 00bfa1b63f30e494 e782d86e
>            16:    2 0000000059bfd413 7acf8521da342228 cd48c018
> 
> Up to this point I did not notice any error or warning in the machines'
> console or kernel logs.
> 
> And then trying to mount on node 8 finally there's an error:
> 
> kern.log node 1:
> 
> (o2hb-0AEE381A14,50990,4):o2hb_check_own_slot:582 ERROR: Another node is
> heartbeating on device (drbd1): expected(1:0x18acf7b0b3e5544c,
> 0x59b8445c), ondisk(8:0xb91302db72a65364, 0x59b8445b)
> 
> kern.log node 8:
> 
> ocfs2: Mounting device (254,16) on (node 8, slot 7) with ordered data mode.
> (o2hb-0AEE381A14,518,1):o2hb_check_own_slot:582 ERROR: Another node is
> heartbeating on device (vdc): expected(8:0x18acf7b0b3e5544c,
> 0x59b8445c), ondisk(1:0x18acf7b0b3e5544c, 0x59b8445c)
> 
> (actual seq and generation are not from above hb debug dump)
> 
> Now we have a conflict on slot 8.
> 
> When I encountered this error for the first time, I didn't know about
> heartbeat debug info, slot maps or heartbeat regions and had no idea
> what might have gone wrong so I started experimenting and found a
> "solution" by swapping nodes 1 <-> 8 in cluster.conf. This leads to the
> following layout of the heartbeat region (?):
> 
> hb
>          node: node              seq       generation checksum
>             1:    1 0000000059bfd412 00bfa1b63f30e494 e782d86e
>             3:    3 0000000059bfd413 59eb77b4db07884b 87a5057d
>             4:    4 0000000059bfd413 debf95d5ff50dc10 3839c791
>             5:    5 0000000059bfd414 529a98c758325d5b 60080c42
>             6:    6 0000000059bfd412 14acfb487fa8c8b8 f54cef9d
>             7:    7 0000000059bfd413 4d2d36de0b0d6b2e 3f1ad275
>            16:    2 0000000059bfd413 7acf8521da342228 cd48c018
>            64:    8 0000000059bfd413 73a63eb550a33095 f4e074d1
> 
> Voila - all 8 nodes mounted, problem solved - let's continue with
> getting this cluster ready for production ...
> 
> As it turned out this was in no way a stable configuration in that after
> few weeks spurious reboots (fencing peer) started to happen (drbd losing
> its replication connection, all kinds of weird kernel oopses and panics
> from drbd and ocfs2). Reboots were usually preceded by burst of errors like:
> 
> Sep 11 00:01:27 web1 kernel: [ 9697.644436]
> (o2hb-10254DCA50,515,1):o2hb_check_own_slot:582 ERROR: Heartbeat
> sequence mismatch on device (vdc): expected(3:0x743493e99d19e721,
> 0x59b5b635), ondisk(3:0x743493e99d19e721, 0x59b5b633)
> Sep 11 00:03:43 web1 kernel: [ 9833.918668]
> (o2hb-10254DCA50,515,1):o2hb_check_own_slot:582 ERROR: Heartbeat
> sequence mismatch on device (vdc): expected(3:0x743493e99d19e721,
> 0x59b5b6bd), ondisk(3:0x743493e99d19e721, 0x59b5b6bb)
> Sep 11 00:03:45 web1 kernel: [ 9835.920551]
> (o2hb-10254DCA50,515,1):o2hb_check_own_slot:582 ERROR: Heartbeat
> sequence mismatch on device (vdc): expected(3:0x743493e99d19e721,
> 0x59b5b6bf), ondisk(3:0x743493e99d19e721, 0x59b5b6bb)
> Sep 11 00:09:10 web1 kernel: [10160.576453]
> (o2hb-10254DCA50,515,0):o2hb_check_own_slot:582 ERROR: Heartbeat
> sequence mismatch on device (vdc): expected(3:0x743493e99d19e721,
> 0x59b5b804), ondisk(3:0x743493e99d19e721, 0x59b5b802)
> 
> In the end the ocfs2 filesystem had to be rebuilt to get rid of the
> errors. It went ok for a while before the same symptoms of fs corruption
> came back again.
> 
> To make a long story short: we found out that the virtual machines did
> not see the disk device having 4k sectors but the standard 512 byte
> blocks. So we had what I coined a "mixed mount" of the same ocfs2 file
> system: 2 nodes mounted with 4k phys. block size the other 6 nodes
> mounted w/ 512 byte block size.
> 
> Configuring the VMs with:
> 
> <blockio logical_block_size='4096' physical_block_size='4096'/>
> 
> leads to a heartbeat slot map:
> 
> hb
>          node: node              seq       generation checksum
>             8:    1 0000000059bfd412 00bfa1b63f30e494 e782d86e
>            16:    2 0000000059bfd413 7acf8521da342228 cd48c018
>            24:    3 0000000059bfd413 59eb77b4db07884b 87a5057d
>            32:    4 0000000059bfd413 debf95d5ff50dc10 3839c791
>            40:    5 0000000059bfd414 529a98c758325d5b 60080c42
>            48:    6 0000000059bfd412 14acfb487fa8c8b8 f54cef9d
>            56:    7 0000000059bfd413 4d2d36de0b0d6b2e 3f1ad275
>            64:    8 0000000059bfd413 73a63eb550a33095 f4e074d1
Could you please also provide information about *slot_map*, just type 
"slotmap" in debugfs.ocfs2 tool. This will be helpful to analysis your case.

Please also paste output generated by :
cat /sys/kernel/config/cluster/<you cluster name>/heartbeat/<file system 
UUID>
So we see how your cluster is configured.
Files like block_bytes, blocks and start_block are preferred.


> 
> Operation is stable so far. No 'Heartbeat sequence mismatch' errors.
> Still strange the "times 8" values in column "node:" but this may be a
> purely aesthetical issue.
I suppose this is because debugfs.ocfs2 *assumes* that block devices are 
all 512 bytes formatted.
Perhaps we can improve this.

> 
> Browsing the code of heartbeat.c I'm not sure if such a "mixed mount" is
> *supposed* to work and it's just a minor bug we triggered that can
> easily be fixed - or if such a scenario is a definite no-no and should
> seriously be avoided. In the latter case an error message and cancelling
> of an inappropriate mount operation would be very helpful.
> 
> Anyway, it would be greatly appreciated to hear a knowledgeable opinion
> from the members of the ocfs2-devel list on this topic - any takers?
> 
> Thanks in advance + Best regards ... Michael
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
