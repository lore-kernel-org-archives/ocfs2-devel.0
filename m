From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Thu, 20 Feb 2014 21:13:25 -0800
Subject: [Ocfs2-devel] [PATCH 0/6 v2] ocfs2: Avoid pending orphaned
	inodes
In-Reply-To: <1392909511-2933-1-git-send-email-jack@suse.cz>
References: <1392909511-2933-1-git-send-email-jack@suse.cz>
Message-ID: <5306E075.7000001@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Jan,

thanks a lot for these patches. They all look good to me ... I just have 
one question on patch 5

Thanks,
--Srini

On 02/20/2014 07:18 AM, Jan Kara wrote:
>    Hello,
>
>    here is a second version of my patchset to solve a deadlocks when we do not
> defer dropping of inode reference from downconvert worker. I have tested the
> patches (also with lockdep enabled) and they seem to work fine. Comments are
> welcome!
>
> 								Honza
