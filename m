From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 17 Nov 2010 15:29:23 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/dlmfs: use GFP_KERNEL instead of
 GFP_NOFS
In-Reply-To: <20101117011235.GA2289@laptop.jp.oracle.com>
References: <201011161537.oAG4gEQI002875@acsinet15.oracle.com>
	<4CE2BD0C.3020501@oracle.com>
	<20101117011235.GA2289@laptop.jp.oracle.com>
Message-ID: <20101117232923.GH25677@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Nov 17, 2010 at 09:12:35AM +0800, Wengang Wang wrote:
> On 10-11-16 09:19, Sunil Mushran wrote:
> > We do NOFS allocs in the dlm to prevent deadlocks (not live locks).
> > And you are right we don't have to do NOFS allocs here. But the sizes
> > we are talking about are really small. Do we really care?
> 
> I didn't hit problem at the allocation with NOFS.
> I just noticed it when looking at the codes.
> Since the sizes are small, it shouldn't effects much.

	I'm going to vote -EDONTCARE.

Joel

-- 

"Friends may come and go, but enemies accumulate." 
        - Thomas Jones

Joel Becker
Senior Development Manager
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
