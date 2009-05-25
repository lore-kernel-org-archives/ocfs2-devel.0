From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 25 May 2009 13:42:14 -0700
Subject: [Ocfs2-devel] [RFC] The reflink(2) system call v4. -
	Question	for suitability
In-Reply-To: <15F26D0D9E18E24583D912511D668FF8026E0568@exchange.ad.tlogica.com>
References: <20090511204011.GB30293@mail.oracle.com>
	<15F26D0D9E18E24583D912511D668FF8026E0568@exchange.ad.tlogica.com>
Message-ID: <20090525204214.GB31322@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, May 25, 2009 at 10:44:11AM +0300, Mihail Daskalov wrote:
> I would like to ask additional question on the reflink semantics. What I
> want to know is what will be the behaviour if you have a file with
> pending modifications, and you do a reflink to it. Will the reflink call
> be atomic in terms of snapshoting ?

	A reflink is atomic - it's a snapshot.  Now, how that interacts
with a userspace process is up to that process.> 

> The context I am asking this is the following:
> Suppose that we have an Oracle database running in a file system that
> supports reflink.
> Will it be possible and safe to use reflink for backup purposes ? e.g. 
>    1) execute "alter tablespace XXX begin backup" sql command
>    2) do a reflink of all datafiles to datafiles.reflinked (e.g. for X
> in (datafiles) do ; reflink X X.reflinked ; done ).
>    3) execute "alter tablespace XXX end backup"
>    4) backup the datafiles.reflinked with some tool
> ?

	That will work, absolutely.

> I understand that Oracle datafile hot backup will not be affected even
> if part of the pending notifications are accepted to the file, and some
> are not - this is the way oracle hot backup is designed to work - so
> this is not a really good example, but it probably illustrates what I
> mean. There might be other cases that need some stability for the file.

	As long as the software can guarantee a state for the duration
of the reflink call, they'll get their snapshot.  The reflink op
actually locks out the file, makes the snap, then unlocks it.  But from
userspace you can only see the duration of the system call.

> Other related issues is which process would get an error if there is
> insufficient space to store data for two different snapshots - will that
> be the writer to the original file, or the reader of the snapshot? I
> guess the writer will get ENOSPACE. But I ask this question anyway...
> Will this be configurable (e.g. through some attribute - e.g.
> GUARANTEE_SPACE_FOR_ORIGINAL_FILE, or ALLOW_ERRORS_READING_SNAPSHOT) ?

	Hmm?  If there isn't enough space to create the new reflink
(the shallow metadata thereof), the snapper gets ENOSPACE.  Once a
reflink is created, no reader should ever get an error that wouldn't
happen outside of a reflink.  The data is always there.
	If someone writes to a snapshot, and CoW ensues, that CoW can,
indeed, get ENOSPACE.  But that's the normal behavior of CoW, and
consistent with all other implementors.  The only way to guarantee space
would be to copy all the data, and then you don't have CoW, do you?

Joel

-- 

"Under capitalism, man exploits man.  Under Communism, it's just 
   the opposite."
				 - John Kenneth Galbraith

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
