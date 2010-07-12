From: Joel Becker <Joel.Becker@oracle.com>
Date: Mon, 12 Jul 2010 11:33:53 -0700
Subject: [Ocfs2-devel] [patch] ocfs2: tighten up strlen() checking
In-Reply-To: <20100710143336.GB19184@bicker>
References: <20100710143336.GB19184@bicker>
Message-ID: <20100712183353.GF12179@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sat, Jul 10, 2010 at 04:33:36PM +0200, Dan Carpenter wrote:
> This function is only called from one place and it's like this:
> 	dlm_register_domain(conn->cc_name, dlm_key, &fs_version);
> 
> The "conn->cc_name" is 64 characters long.  If strlen(conn->cc_name)
> were equal to O2NM_MAX_NAME_LEN (64) that would be a bug because
> strlen() doesn't count the NULL character.
> 
> In fact, if you look how O2NM_MAX_NAME_LEN is used, it mostly describes
> 64 character buffers.  The only exception is nd_name from struct
> o2nm_node.
> 
> Anyway I looked into it and in this case the domain string comes from
> osb->uuid_str in ocfs2_setup_osb_uuid().  That's 32 characters and NULL
> which easily fits into O2NM_MAX_NAME_LEN.  This patch doesn't change how
> the code works, but I think it makes the code a little cleaner.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

	This patch is now in the fixes branch of ocfs2.git.

Joel

-- 

Viro's Razor:
	Any race condition, no matter how unlikely, will occur just
	often enough to bite you.

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
