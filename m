From: Ling, Xiaofeng <xiaofeng.ling@intel.com>
Date: Tue Jun  8 01:44:28 2004
Subject: [Ocfs2-devel] Is this bug?
Message-ID: <3ACA40606221794F80A5670F0AF15F840492FB1C@pdsmsx403>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I mount a ocfs2 on two node,  when I create a directory in one node's
ocfs root,
I can not see it from another node at once. Until I create another
directory on the seconds node,
then I can see both the one create on first node and the one create on
local.
But when I tried the same thing in a subdiretory, this did not happen. I
can see at once from another node.
Not sure whether it is bug or designed so?
Process:
Node A:
mkdir /ocfs/foo
Node B:
ls /ocfs
output >nothing
Node B:
mkdir /ocfs/foo2
ls /ocfs
output> foo foo2
