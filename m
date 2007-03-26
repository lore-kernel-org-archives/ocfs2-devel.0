From: Adrian Bunk <bunk@stusta.de>
Date: Mon Mar 26 15:34:50 2007
Subject: [Ocfs2-devel] [RFC: 2.6.16 patch] ocfs2 heartbeat: clean up bio
	submission code
In-Reply-To: <20070326115717.GA16201@localhost.localdomain>
References: <20070324114213.GC752@stusta.de>
	<17927.4509.867938.738430@notabene.brown>
	<20070326115717.GA16201@localhost.localdomain>
Message-ID: <20070326223449.GJ16477@stusta.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Mar 26, 2007 at 01:57:17PM +0200, Lars Ellenberg wrote:
> 
> uhm, how about 
> 
>   commit b559292e066f6d570cd5aa5dbd41de61dd04bdce
>   tree d8221b5f54ad9b8cef694de687013614dccf5966
>   parent 925037bcba7691db2403684141a276930ad184f3
>   author Philipp Reisner <philipp.reisner@linbit.com> Thu, 11 Jan 2007 10:58:10 +0100
>   committer Mark Fasheh <mark.fasheh@oracle.com> Wed, 07 Feb 2007 12:15:58 -0800
>   
>       [PATCH] ocfs2 heartbeat: clean up bio submission code
> 
> pretty please?

It doesn't apply without rejects and seems non-trivial.

I need a patch that:
- applies and
- was runtime tested with 2.6.16.45 and
- got approved by the OCFS2 maintainers as being low-risk.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed
