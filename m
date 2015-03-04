From: Gang He <ghe@suse.com>
Date: Tue, 03 Mar 2015 20:26:08 -0700
Subject: [Ocfs2-devel] some problem encountered when running ocfs2-test
Message-ID: <54F6EBD0020000F900004211@relay2.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello ocfs2 developers,

I and Zhen are new for ocfs2 project, we are looking at ocfs2-test testing suits for evaluating the ocfs2/ocfs2-tools quality, now there are some problem encountered when running ocfs2-test.
1) How to evaluate ocfs2/ocfs2-tools after you add some new code? only use ocfs2-test? but it has been inactive for 2 years. I just want to know if there is any other test suits, hope some old people can give some suggestions.
2) We set up a ocfs2 cluster under openSuSe 13.2, tried to run ocfs2-test-1.0.4 test suits, but two cases cannot pass, just want to know who encounter the similar problem and how to fix.
2.1) run_mmaptruncate, run this case in the condition "blocksize=4096 clustersize=1048576 sparse,unwritten,inline-data  data=writeback" will be hanged.
2.2) run_reflink_test, run to this step "[11] OracleVM Data Integrity Test", this will last lots of time and then let this VM node reboot, this test case cannot be completed.


Thanks
Gang   
