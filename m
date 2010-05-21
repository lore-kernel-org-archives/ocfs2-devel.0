From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 21 May 2010 03:22:22 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Add new OCFS2_IOC_INFO ioctl
 for ocfs2 v7.
In-Reply-To: <4BF64D3F.5030705@oracle.com>
References: <1274236135-5383-1-git-send-email-tristan.ye@oracle.com>
	<20100520232643.GC8335@mail.oracle.com>
	<20100520234955.GD8335@mail.oracle.com>
	<4BF64D3F.5030705@oracle.com>
Message-ID: <20100521102222.GA6827@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, May 21, 2010 at 05:07:11PM +0800, tristan wrote:
> That's definitely a MUST!! since I caught another bug running 32bits 
> application on 64bits kernel, the problem is I didn't make the 
> 'ocfs2_info' structure 64bits aligned, which caused a failure to 
> recognize this ioctl from a 32bits application. Following is all that 
> I'm going to change against this issue:
> 
> --------------------------------------------------------------------------
> struct ocfs2_info {
> __u64 oi_requests; /* Array of __u64 pointers to requests */
> - __u32 oi_count; /* Number of requests in info_requests */
> + __u64 oi_count; /* Number of requests in info_requests */
> };

	Don't turn these values into 64bit ones.  Instead, pad the
structure:

struct ocfs2_info {
	__u64 oi_requests;
	__u32 oi_count;
	__u32 oi_pad;
};

That way you can change the structure later to use the pad field without
breaking old code.

Joel

-- 

"Any man who is under 30, and is not a liberal, has not heart;
 and any man who is over 30, and is not a conservative, has no brains."
         - Sir Winston Churchill 

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
