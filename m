From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 5 Aug 2008 16:22:55 -0700
Subject: [Ocfs2-devel] [PATCH] ocfs2/cluster/netdebug.c: fix warning
In-Reply-To: <20080805205041.GD17320@orion>
References: <20080805201036.GC17320@orion>
	<20080805202948.GL22600@mail.oracle.com>
	<20080805205041.GD17320@orion>
Message-ID: <20080805232254.GO22600@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: mfasheh@suse.com, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

On Wed, Aug 06, 2008 at 12:50:41AM +0400, Alexander Beregalov wrote:
> On Tue, Aug 05, 2008 at 01:29:48PM -0700, Joel Becker wrote:
> > 	suseconds_t is a signed long.  Can you change the format to %ld
> > and cast to long?  Unfortunately, we need the cast, as sparc64 and
> > parisc treat it as int.
> 
> Then we should change cast from unsigned long to long for every tv_usec, right?

	Yup.

Joel

-- 

"You can get more with a kind word and a gun than you can with
 a kind word alone."
         - Al Capone

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
