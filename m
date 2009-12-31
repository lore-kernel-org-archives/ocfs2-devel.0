From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 31 Dec 2009 12:08:36 -0800
Subject: [Ocfs2-devel] 40TB RAID and OCFS2 woes (inode64, JDB2,
 huge partition support,
 Volume might try to write to blocks beyond what jbd can address in 32 bits)
In-Reply-To: <6575F4FA-312C-4CB4-AA92-6AF7ECEF3EEA@wansecurity.com>
References: <9A9AABD3-F67F-46D3-B08C-4FD89CA16149@wansecurity.com>
	<20091230203426.GA7272@mail.oracle.com>
	<1D016AC1-13F8-4433-9E1D-6540302C0373@wansecurity.com>
	<20091231034243.GA2560@mail.oracle.com>
	<E8CB0062-5A3B-4853-9804-8F345404A635@wansecurity.com>
	<4B3CF610.4070603@oracle.com>
	<6575F4FA-312C-4CB4-AA92-6AF7ECEF3EEA@wansecurity.com>
Message-ID: <20091231200836.GA3301@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jan 01, 2010 at 04:36:02AM +0900, Robert Smith wrote:
> Oh, I found it at line #2163 of fs/ocfs2/super.c.
> 
> I imagine that something as simple as the following would work, but perhaps I'll wait for your feedback.
> 
> 
> /*
>         if (ocfs2_clusters_to_blocks(osb->sb, le32_to_cpu(di->i_clusters) - 1)
>             > (u32)~0UL) {
>                 mlog(ML_ERROR, "Volume might try to write to blocks beyond "
>                      "what jbd can address in 32 bits.\n");
>                 status = -EINVAL;
>                 goto bail;
>         }
> */

	That should work.  The real solution will check based on the
journal flags.  Be warned, there be tygers in here.

Joel

-- 

"But all my words come back to me
 In shades of mediocrity.
 Like emptiness in harmony
 I need someone to comfort me."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
