From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 4 Mar 2009 18:38:02 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] OCFS2: anti stale inode for nfs (V6)
In-Reply-To: <49AF39B2.5080803@oracle.com>
References: <200903030232.n232W2xF026375@acsinet13.oracle.com>
	<20090305012406.GA8700@mail.oracle.com>
	<49AF39B2.5080803@oracle.com>
Message-ID: <20090305023802.GB18729@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Mar 05, 2009 at 10:32:18AM +0800, Wengang Wang wrote:
>> Wengang,
>> 	Thanks for working so hard on this.  
>
> My pleasure! and I also learnt during the progress:)
>
> I'm going to poke Mark to
>> include it.  Now we can go back and do the 1.4 patch.  Can you cook that
>> up?  It should be almost the same.
>
> sure.
> well, what about 1.2?

	1.2 has a very different scheme, and I don't think we need to
worry about it.  1.4 has been out and stable for a while now.

Joel

-- 

"There are only two ways to live your life. One is as though nothing
 is a miracle. The other is as though everything is a miracle."
        - Albert Einstein

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
