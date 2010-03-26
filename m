From: tristan <tristan.ye@Oracle.com>
Date: Fri, 26 Mar 2010 09:12:30 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Teach truncating and
 punching-hole codes to handle fastsymlink.
In-Reply-To: <4BABAA9D.7080702@oracle.com>
References: <1269331484-21262-1-git-send-email-tristan.ye@oracle.com>	<20100323195224.GA31783@mail.oracle.com>	<4BA96675.80506@oracle.com>	<20100324021306.GH31783@mail.oracle.com>
	<4BA97745.8040009@oracle.com> <4BABAA9D.7080702@oracle.com>
Message-ID: <4BAC09FE.2000503@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Sunil Mushran wrote:
> tristan wrote:
>>>> Not exactly,
>>>>
>>>> Sunil reported such a bug from userspace in libocfs2, I suddenly 
>>>> realised that we could also do the same in fs.
>>>>       
>>>     
>
> I did not see the patch for libocfs2? Is it in the pipeline or did
> I miss it?

Oh,

I did send it along with 'setting dtime' patch, let me forward the patch 
to you.

Tristan.
