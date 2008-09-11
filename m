From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 10 Sep 2008 20:05:53 -0700
Subject: [Ocfs2-devel] Some more debug stuff
Message-ID: <1221102357-869-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Added two debugfs entries... one to dump o2hb livenodes and the other
to dump osb.

$ cat /sys/kernel/debug/ocfs2/BC4F4550BEA74F92BDCC746AAD2EC0BF/fs_state
  Device => Id: 8,65  Uuid: BC4F4550BEA74F92BDCC746AAD2EC0BF  Gen: 0xA02024F2  Label: sunil-xattr
  Volume => State: 1  Flags: 0x0
   Sizes => Block: 4096  Cluster: 4096
Features => Compat: 0x1  Incompat: 0x350  ROcompat: 0x1
   Mount => Opts: 0x1  AtimeQuanta: 60
 Cluster => Stack: o2cb  Name: BC4F4550BEA74F92BDCC746AAD2EC0BF  Version: 1.0
DownCnvt => Pid: 7330  Count: 0  WakeSeq: 149  WorkSeq: 149
Recovery => Pid: -1  Nodes: None
  Commit => Pid: 7335  Interval: 0  Needs: 1
 Journal => State: 1  NumTxns: 32521  TxnId: 67
   Stats => GlobalAllocs: 140  LocalAllocs: 192825 SubAllocs: 73299  LAWinMoves: 140  SAExtends: 72
   Steal => Slot: -1  NumStolen: 0
   Slots => Num   Node     RecoGen
          *   0     92           2
              1     96           0
              2     -1           0
              3     -1           0

Sunil
