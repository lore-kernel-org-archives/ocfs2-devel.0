From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 18 Dec 2008 17:43:11 -0800
Subject: [Ocfs2-devel] [PATCH 01/18] jbd2: Add buffer triggers
In-Reply-To: <20081219004005.GG8424@duck.suse.cz>
References: <1228871395-10273-1-git-send-email-joel.becker@oracle.com>
	<1228871395-10273-2-git-send-email-joel.becker@oracle.com>
	<20081213004512.GD15241@mail.oracle.com>
	<20081218180820.GC6797@atrey.karlin.mff.cuni.cz>
	<20081219003224.GC21870@mail.oracle.com>
	<20081219004005.GG8424@duck.suse.cz>
Message-ID: <20081219014311.GD21870@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: mfasheh@suse.com, linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, ocfs2-devel@oss.oracle.com

On Fri, Dec 19, 2008 at 01:40:05AM +0100, Jan Kara wrote:
> On Thu 18-12-08 16:32:25, Joel Becker wrote:
>   Yeah, I was just wondering why we don't do:
> jbd2_buffer_abort_trigger(jh)
>   and choose the proper set of triggers in the jbd2_buffer_abort_trigger()
> function (and similarly for the commit trigger). Or does it make sence
> to not call frozen trigger in some place if there're frozen data set?

	When I wrote it up, I was worried about that.  Right now, I
don't think it's a problem.  But really, that's a cleanup.

Joel

-- 

Life's Little Instruction Book #337

	"Reread your favorite book."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
