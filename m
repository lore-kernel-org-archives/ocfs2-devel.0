From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue Oct 18 17:18:46 2005
Subject: [Ocfs2-devel] [RFC] Integration with external clustering
In-Reply-To: <43556F8B.3060105@suse.com>
References: <43556F8B.3060105@suse.com>
Message-ID: <20051018221849.GN11488@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Oct 18, 2005 at 05:56:27PM -0400, Jeff Mahoney wrote:
> I'll start with an idea of what I'd like to see the configfs space look
> like, since I think it will probably illustrate it best:
> 
> /config/cluster/ocfs2/<fs uuid>/<node>/

	If you are treating each mount as a 'cluster', the ocfs2 path
element is pretty redundant, and /config/cluster/<fs uuid> would
suffice.
	Given that heartbeat regions can and should be shared, you need
a way to describe this.  We don't have userspace doing global heartbeat
yet, but there is no reason that all OCFS2 volumes can't share one
heartbeat region (see
http://oss.oracle.com/projects/ocfs2-tools/src/branches/global-heartbeat/documentation/o2cb/).
	Have you also considered what this will or won't do to possible
interaction with the CMan stack?  We'd love OCFS2 to handle both stacks.
	Finally, have you considered the user barriers to this?  The
absolute bottom-line goal of O2CB is the minimum input by the user.  For
this to work, the user should not have to see the plethora of XML config
files that heartbeat has (or at least, used to have).  I'm talking about
the user-visible part here, not the technical reality.  The O2CB
frontend or some other piece of software can take the user's name:ip
node mapping and turn it into whatever XML it needs, but the user
shouldn't have to do anything more than ocfs2console requires them
today.

Joel


-- 

"If you took all of the grains of sand in the world, and lined
 them up end to end in a row, you'd be working for the government!"
	- Mr. Interesting

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
