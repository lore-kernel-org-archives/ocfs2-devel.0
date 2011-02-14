From: Joel Becker <jlbec@evilplan.org>
Date: Mon, 14 Feb 2011 14:25:25 -0800
Subject: [Ocfs2-devel] [PATCH] Zero from EOF instead of next block
In-Reply-To: <AANLkTikPdMgJWexFbBx8fRKxwAoKGsbiYkHR49Kfk90=@mail.gmail.com>
References: <AANLkTik_4d7Ey5LCcV7pQMXEeZ_GcN-gC6cK-oX7f+B9@mail.gmail.com>
	<20110214072503.GA8413@noexit>
	<AANLkTikTP7wtSGsoUSw1pVT6aWDrjSYFrn_A+8Aam9HD@mail.gmail.com>
	<20110214220021.GB8413@noexit>
	<AANLkTikPdMgJWexFbBx8fRKxwAoKGsbiYkHR49Kfk90=@mail.gmail.com>
Message-ID: <20110214222524.GD8413@noexit>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Feb 14, 2011 at 04:16:37PM -0600, Goldwyn Rodrigues wrote:
> Oh, I thought the test case was self-explanatory. The test case first writes
> a lot of dirty data on disk "0xbaadfeed", syncs the data and removes
> the file so that the filesystem has a lot of "0xbaadfeed" data on it.
> 
> The second executable writes records of 32 bytes and seeks another 32
> bytes. While reading the file back, 0xbaadfeed is read when zeros are
> expected. The program shows where the unexpected data is found.
> 
> So, for holes not spanning extents or even blocks, the data which was
> on disk previously shows up.

	That shouldn't happen, of course.  But the solution will not be
writing past the last block of the file.  We should be catching it
instead when extending the i_size into a previously uninitialized block.

Joel

-- 

"One of the symptoms of an approaching nervous breakdown is the
 belief that one's work is terribly important."
         - Bertrand Russell 

			http://www.jlbec.org/
			jlbec at evilplan.org
