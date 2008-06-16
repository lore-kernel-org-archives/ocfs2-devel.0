From: Louis Rilling <Louis.Rilling@kerlabs.com>
Date: Mon, 16 Jun 2008 20:14:28 +0200
Subject: [Ocfs2-devel] [RFC] configfs: module reference counting rules
In-Reply-To: <20080616180643.GC9657@mail.oracle.com>
References: <20080612235410.GC4012@localdomain>
	<20080613033309.GE20581@mail.oracle.com>
	<20080613095159.GH30804@localhost>
	<20080613202605.GD20576@mail.oracle.com>
	<20080613222744.GB4153@localdomain>
	<20080614084701.GA9657@mail.oracle.com>
	<20080616123912.GR30804@localhost>
	<20080616180643.GC9657@mail.oracle.com>
Message-ID: <20080616181428.GW30804@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel.Becker@oracle.com
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

On Mon, Jun 16, 2008 at 11:06:43AM -0700, Joel Becker wrote:
> > > 	Why can't mod_b provide a ->release() that does
> > > module_put(self)?
> > 
> > Because this is simply wrong. Doing module_put(self) exposes the modules's
> > function to be run while another cpu unloads the module. Note how I solve this
> 
> 	How so?  As long as the module_put() is the last thing, you're
> fine.  That said, we both have better solutions with our wrappered
> functions.

With a preemptible kernel, after module_put(self) the few assembly instructions
cleaning up the stack before returning to the caller can be called after the
memory allocated for the module has been freed. Which will make the kernel
crash.

Louis

-- 
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes
-------------- next part --------------
A non-text attachment was scrubbed...
Name: not available
Type: application/pgp-signature
Size: 189 bytes
Desc: Digital signature
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20080616/4cf790f2/attachment.bin 
