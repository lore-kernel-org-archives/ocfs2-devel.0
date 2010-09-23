From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 23 Sep 2010 15:37:23 -0700
Subject: [Ocfs2-devel] Global Heartbeat - fs patches
In-Reply-To: <1284504656-2434-1-git-send-email-sunil.mushran@oracle.com>
References: <1284504656-2434-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20100923223723.GH803@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Sep 14, 2010 at 03:50:36PM -0700, Sunil Mushran wrote:
> 
> So this is the next drop of the global heartbeat patches that have been
> rebased with current mainline head. The patches are feature-wise complete.
> 
> Please refer to this wiki to learn more on this feature.
> http://oss.oracle.com/osswiki/OCFS2/DesignDocs/NewGlobalHeartbeat
> 
> Please review.

	My review is done.  It's all pretty clean stuff; well done,
Sunil.  Most of my review is cosmetic.
	The one big thing that needs to change is that the default
dlm_protocol cannot be bumped until all the functionality is there.
After the messages are added.  After the quorum calculation is updated.
Just make it the last patch of the series.

Joel

-- 

 print STDOUT q
 Just another Perl hacker,
 unless $spring
	- Larry Wall

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
