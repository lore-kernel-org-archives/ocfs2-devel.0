From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date: Tue, 18 Feb 2020 11:07:31 +0100
Subject: [Ocfs2-devel] [PATCH 12/44] docs: filesystems: convert
	dlmfs.txt to ReST
In-Reply-To: <3b40d7d4-3798-08db-220d-b45704ada48a@linux.alibaba.com>
References: <cover.1581955849.git.mchehab+huawei@kernel.org>
	<efc9e59925723e17d1a4741b11049616c221463e.1581955849.git.mchehab+huawei@kernel.org>
	<3b40d7d4-3798-08db-220d-b45704ada48a@linux.alibaba.com>
Message-ID: <20200218110731.2890658d@kernel.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, linux-fsdevel@vger.kernel.org, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com

Em Tue, 18 Feb 2020 09:21:51 +0800
Joseph Qi <joseph.qi@linux.alibaba.com> escreveu:

> On 20/2/18 00:11, Mauro Carvalho Chehab wrote:

> > @@ -96,14 +101,19 @@ operation. If the lock succeeds, you'll get an fd.
> >  open(2) with O_CREAT to ensure the resource inode is created - dlmfs does
> >  not automatically create inodes for existing lock resources.
> >  
> > +============  ===========================
> >  Open Flag     Lock Request Type
> > ----------     -----------------  
> 
> Better to remove the above line.
> 
> > +============  ===========================
> >  O_RDONLY      Shared Read
> >  O_RDWR        Exclusive
> > +============  ===========================
> >  
> > +
> > +============  ===========================
> >  Open Flag     Resulting Locking Behavior
> > ----------     --------------------------  
> 
> Ditto.

Ok. So, I guess we can just merge the two tables into one, like:

	============  =================
	O_RDONLY      Shared Read
	O_RDWR        Exclusive
	O_NONBLOCK    Trylock operation
	============  =================

Right?

Cheers,
Mauro
