From: Roel Kluin <12o3l@tiscali.nl>
Date: Sun Mar  9 11:51:51 2008
Subject: [Ocfs2-devel] Re: fs/ocfs2/cluster/heartbeat.c: misplaced
	parentheses in o2hb_setup_one_bio()?
In-Reply-To: <47D42DBD.7030207@tiscali.nl>
References: <47D42DBD.7030207@tiscali.nl>
Message-ID: <47D431AD.4050306@tiscali.nl>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Roel Kluin wrote:
> from fs/ocfs2/cluster/heartbeat.c:265:
> 
> vec_start = (cs << bits) % PAGE_CACHE_SIZE;
> 
> shouldn't this be
> 
> vec_start = cs << (bits % PAGE_CACHE_SIZE);
> 
> ?

Nevermind, it is probably right. Sorry for the noise.
