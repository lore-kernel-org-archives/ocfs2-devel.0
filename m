From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon, 27 Dec 2010 08:52:26 -0800
Subject: [Ocfs2-devel] disk full when it shouldn't
In-Reply-To: <4D18B54E.1030203@tao.ma>
References: <4CD813D3.4080106@navynet.it>	<4CD89E86.5010404@oracle.com>	<4CF7D578.1060201@navynet.it>	<4CF84658.8040002@oracle.com>
	<4D18A327.7030709@navynet.it> <4D18B54E.1030203@tao.ma>
Message-ID: <4D18C44A.5050103@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 12/27/2010 07:48 AM, Tao Ma wrote:
> So you have to enable that feature by tunefs.ocfs2. I am afraid Oracle
> didn't release a new ocfs2-tools now(I had left Oracle and I don't know
> the release detail now), so you need to download the latest source and
> compile the ocfs2-tools by yourself.
> git clone git://oss.oracle.com/git/ocfs2-tools.git
> and after you compile it, just do
> tunefs.ocfs2 --fs-features=discontig-bg /dev/sdx.
> And you will enable this feature(it will require you to umount the
> volume among all the nodes) and enjoy it.:)

The source tarball is available here.

http://oss.oracle.com/projects/ocfs2-tools/files/source/v1.6/

Ping your distro for the packages.
