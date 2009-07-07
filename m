From: David Teigland <teigland@redhat.com>
Date: Tue, 7 Jul 2009 11:01:13 -0500
Subject: [Ocfs2-devel] lvb length issue [was Re: [ocfs2-tools-devel]
	question of ocfs2_controld (Jun 27)]
In-Reply-To: <4A51ED7F.2040105@suse.de>
References: <4A451AB5.9070908@suse.de> <20090626193436.GC4478@mail.oracle.com>
	<4A45257C.6040704@suse.de> <20090629080023.GB8373@mail.oracle.com>
	<4A51ED7F.2040105@suse.de>
Message-ID: <20090707160113.GA9140@redhat.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Jul 06, 2009 at 08:26:39PM +0800, Coly Li wrote:
> DLM_USER_LVB_LEN is defined to 32.

> DLM_LVB_LEN is 64.

Yes, the kernel dlm api allows a variable lvb size, but the user dlm api fixes
it at 32.

Do you need to actually use a 64 byte lvb from userspace?  Or do you just need
to create the locksapce with a 64 byte lvb?  We could add a flag to work
around the later fairly easily.  Changing the dlm user/kernel interface to
copy variable size lvb's would take some significant work.

Dave
