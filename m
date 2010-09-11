From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 10 Sep 2010 20:52:10 -0700
Subject: [Ocfs2-devel] [PATCH 5/5] ocfs2/dlm: make dynamic lvb alloc work
In-Reply-To: <4C8ACBD3.4090706@oracle.com>
References: <201008261310.o7Q90KvJ016660@acsinet15.oracle.com>
	<4C8ACBD3.4090706@oracle.com>
Message-ID: <20100911035210.GL885@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Sep 10, 2010 at 05:22:43PM -0700, Sunil Mushran wrote:
> BTW, you are forgetting user_dlm. Not userspace dlm, but user dlm.
> So the premise here is that we can skip allocating space for the lvb
> based on the lockname. That will work for fs locks. But not for dlmfs/
> userdlm because we allow users to create any lockname.
> 
> Now granted we can then say that lvb is not available for userdlm.
> But we do provide that facility right now.

	We are not taking away the lvb for userdlm.  So userdlm would
have to always allocate, I guess.

Joel

-- 

"Heav'n hath no rage like love to hatred turn'd, nor Hell a fury,
 like a woman scorn'd."
        - William Congreve

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
