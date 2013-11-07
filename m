From: Joseph Qi <joseph.qi@huawei.com>
Date: Thu, 7 Nov 2013 20:12:02 +0800
Subject: [Ocfs2-devel] ocfs2: a dead lock case when running
	dirop_fileop_racer
Message-ID: <527B8392.8010807@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We ran ocfs2 test program dirop_fileop_racer and found a dead lock case.

The case is described below.
2 nodes, say Node A and Node B, mount the same ocfs2 volume. Create
/race/16/1 in the filesystem, and let the inode number of dir 16 is less
than the inode number of dir race.

Node A                            Node B
mv /race/16/1 /race/
                                  right after Node A has got the
                                  EX mode of /race/16/, and tries to
                                  get EX mode of /race
                                  ls /race/16/

In this case, Node A has got the EX mode of /race/16/, and wants to get
EX mode of /race/. Node B has got the PR mode of /race/, and wants to
get the PR mode of /race/16/. Since EX and PR are mutually exclusive,
dead lock happens.
