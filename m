From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 16 Jun 2008 12:36:14 -0700
Subject: [Ocfs2-devel] [RFC] configfs: module reference counting rules
In-Reply-To: <20080616181428.GW30804@localhost>
References: <20080612235410.GC4012@localdomain>
	<20080613033309.GE20581@mail.oracle.com>
	<20080613095159.GH30804@localhost>
	<20080613202605.GD20576@mail.oracle.com>
	<20080613222744.GB4153@localdomain>
	<20080614084701.GA9657@mail.oracle.com>
	<20080616123912.GR30804@localhost>
	<20080616180643.GC9657@mail.oracle.com>
	<20080616181428.GW30804@localhost>
Message-ID: <20080616193614.GB6441@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

On Mon, Jun 16, 2008 at 08:14:28PM +0200, Louis Rilling wrote:
> With a preemptible kernel, after module_put(self) the few assembly instructions
> cleaning up the stack before returning to the caller can be called after the
> memory allocated for the module has been freed. Which will make the kernel
> crash.

	Ahh, but if you are running a preemptible kernel, you've already
made your first mistake :-)

Joel

-- 

"Vote early and vote often." 
        - Al Capone

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
