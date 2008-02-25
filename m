From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon Feb 25 12:21:13 2008
Subject: [Ocfs2-devel] New dlm debug infrastructure
Message-ID: <1203970862-8790-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

These patches include the following:
1. Use slabs for struct dlm_lock_resource and struct dlm_lock allocations.
2. Fix memory leaks detected wrt to the above 2 structures.
3. Add debugfs interface to allow users to dump dlm_state, lockres, mles, etc.
4. Remove the older proc interface for the same.

The lockres state dump uses the fs_locks model in that the fs dumps raw
information that the dlm_locks command in debugfs.ocfs2 makes readable.
Example is shown below.

Sunil

$ cat /sys/kernel/debug/o2dlm/.../locking_state
NAME:M00000000000000000000058cf07918
LRES:1,96,0,0,0,0,0,0,0,0,4
RMAP:92
LVBX:0500000000000001000000000000000011f0c6ddb9444bb411f0c44add11180911f0c44add111809000000000000100041ed0005000000008cf0791800000000
LOCK:1,0,0,-1,96,96:4,0,0,0,0,0,0,0,0,2
LOCK:1,0,5,-1,92,92:3,0,0,0,0,0,0,0,0,2

$ debugfs.ocfs2 -R "dlm_locks -l M00000000000000000000058cf07918" /dev/sdX
Lockres: M00000000000000000000058cf07918   Owner: 96   State: 0x0
Last Used: 0      ASTs Reserved: 0    Inflight: 0    Migration Pending: No
Refs: 4    Locks: 2    On Lists: None
Reference Map: 92
Raw LVB:	05 00 00 00 00 00 00 01 00 00 00 00 00 00 00 00
		11 f0 c6 dd b9 44 4b b4 11 f0 c4 4a dd 11 18 09
		11 f0 c4 4a dd 11 18 09 00 00 00 00 00 00 10 00
		41 ed 00 05 00 00 00 00 8c f0 79 18 00 00 00 00
 Lock-Queue  Node  Level  Conv  Cookie           Refs  AST  BAST  Pending-Action
 Granted     96    NL     -1    96:4             2     No   No    None
 Granted     92    EX     -1    92:3             2     No   No    None
