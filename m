From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Feb 23 18:23:35 2004
Subject: [Ocfs2-devel] Re: [PATCH]2.6 fixes in nm.c
In-Reply-To: <200402200413.i1K4DwFC004269@penguin.co.intel.com>
References: <200402200413.i1K4DwFC004269@penguin.co.intel.com>
Message-ID: <20040224002331.GG1421@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Feb 19, 2004 at 08:13:58PM -0800, Rusty Lynch wrote:
> The following patch enables inode syncing on 2.6 kernels in the 
> nm.c file.
> 
>     --rusty

Damn, I missed some of the LINUX_2_5 conditionals that stayed in even after
the patch... You mind sending me a patch that replaces the rest of them in
nm.c? I've committed the other parts of the patch so you don't have to worry
about that :)

In fact, feel free to send me patches to remove them in the rest of the 
files ;)
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
