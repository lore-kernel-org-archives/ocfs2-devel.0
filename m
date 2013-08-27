From: David Weber <wb@munzinger.de>
Date: Tue, 27 Aug 2013 10:48:54 +0200
Subject: [Ocfs2-devel] fcntl(2) support with o2cb
Message-ID: <5221255.1zJqs1Yu26@o3-3>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

as far as I understand the current situation with locking looks like this:

- o2cb supports cluster-aware flock(2). fcntl(2) locks are only local.
- Pacemaker and cman also support cluster-aware fcntl(2)
- There is no way for a userspace program to check if fcntl(2) is cluster-
aware or not

Is this correct?

We would like to stick with the o2cb cluster stack but there are applications 
like virtlockd out of the libvirt project which (at least at the moment) 
require fcntl(2) support. How much work would it be to implement cluster-aware 
fcntl(2) support for o2cb?

Thanks in advance!

Cheers,
David
