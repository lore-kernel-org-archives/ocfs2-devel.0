From: Sunil Mushran <Sunil.Mushran@oracle.com>
Date: Wed Mar  5 10:42:18 2008
Subject: [Ocfs2-devel] Re: [PATCH] Dynamic lockres hash table
In-Reply-To: <20080305182618.GA10416@duck.suse.cz>
References: <20080304102448.GB24335@duck.suse.cz> <47CE065F.6080707@oracle.com>
	<20080305182618.GA10416@duck.suse.cz>
Message-ID: <47CEE95E.8020200@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Jan Kara wrote:
>   Actually, it's non-trivial to measure (differently than by profiling).
> You cannot use standard time functions because they have too low resolution
> - we are speaking about microseconds here...
>   

jiffies should have enough resolution.

>   Definitely, they should have 16 or even 32 pages per mount.  With 500K
> lockres, which is not so extreme on bigger FS, 16 pages mean hash chains of
> average length 61 on x86_64. It is not ideal but I guess it should be
> sufficient.
>   

Any objections to increasing the default to 32 pages for 1.4?
