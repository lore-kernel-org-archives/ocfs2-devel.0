From: Gang He <ghe@suse.com>
Date: Wed, 27 Sep 2017 00:38:40 -0600
Subject: [Ocfs2-devel] ocfs2-test supports Python 3
Message-ID: <59CBB7F0020000F90008F634@prv-mh.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

** PRIVATE **

Hello guys,

As you know, some Linux distributions(e.g. SUSE Enterprise Linux 15) will introduce Python3 as the default,  
our Python scripts in ocfs2-test still use Python2, we will have to do proper modifications to migration to Python3 (Larry Chen has worked on this investigation).
But, the problem is how to maintain the ocfs2-test code between Python2 and Python3? since some existing Linux distributions(include their further SP) use Python2.
there are two options,
1) one code branch, in which the code is compatible with Python2 and Python3, but I feel it is difficult after I talked with Larry Chen. 
2) two code branches, one branch is for Python2, the other branch is for Python3.
what are your thoughts? please let us know, then we can select a way to work on this task.
  

Thanks
Gang
