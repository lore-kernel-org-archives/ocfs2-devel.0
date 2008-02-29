From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Fri Feb 29 13:40:29 2008
Subject: [Ocfs2-devel] endian bug?
Message-ID: <20080229213936.GE9349@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Compiling with sparse today, I get:

fs/ocfs2/resize.c:600:16: warning: cast to restricted type
fs/ocfs2/resize.c:600:14: warning: incorrect type in assignment (different
base types)
fs/ocfs2/resize.c:600:14:    expected restricted unsigned long long
[usertype] c_blkno
fs/ocfs2/resize.c:600:14:    got unsigned long long [unsigned] [usertype]
<noident>


Which in my tree is:

	cr->c_blkno = le64_to_cpu(input->group);

where 'cr' is of type 'ocfs2_chain_rec'... This looks wrong to me, would you
care to verify (and send a patch)?
	--Mark

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
