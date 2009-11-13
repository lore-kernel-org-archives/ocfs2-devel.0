From: Hoot, Joseph <joe.hoot@itec.suny.edu>
Date: Fri, 13 Nov 2009 11:27:08 -0500
Subject: [Ocfs2-devel] disable reboots when fencing
Message-ID: <DB7C4A32-5E4B-48DA-8456-CDBDD025ACEB@itec.suny.edu>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

What is the OCFS2 v1.4 equivalent to the OCFS2 v1.2 command to disable reboots upon fencing?

 echo 1 > /proc/fs/ocfs2_nodemanager/fence_method 

Thanks,
Joe

===========================
Joseph R. Hoot
Lead System Programmer/Analyst
(w) 716-878-4832
(c) 716-759-HOOT
joe.hoot at itec.suny.edu
GPG KEY:   7145F633
===========================
