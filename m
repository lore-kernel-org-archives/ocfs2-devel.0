From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 22 Apr 2008 16:19:28 -0700
Subject: [Ocfs2-devel] ocfs2-tools fedora rpm
Message-ID: <20080422231927.GV31299@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

After a lot of waiting, the ocfs2-tools rpm for fedora 8 has been approved.
It's in the "testing" repository right now. Could any interested parties who
have fedora 8 installed give it a quick whirl and provide positive feedback
at the following url?

https://admin.fedoraproject.org/updates/F8/FEDORA-2008-3245

The rpm can be easily installed from the command line like so:

su -c 'yum --enablerepo=updates-testing update ocfs2-tools'


This should fill in a large hole in our distro coverage. From the top of my
head, OpenSUSE, Debian, Ubuntu, SLES and EL (via Oracle) have had
ocfs2-tools rpms forever.
	--Mark

--
Mark Fasheh
