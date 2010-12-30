From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 30 Dec 2010 15:32:19 -0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: lock the page in
 __ocfs2_page_mkwrite() -v2
In-Reply-To: <20101216125606.GA17398@laptop.jp.oracle.com>
References: <201011181554.oAIFs5a5031128@rcsinet15.oracle.com>
	<20101214174450.GB9240@wotan.suse.de>
	<20101216125606.GA17398@laptop.jp.oracle.com>
Message-ID: <20101230233219.GB931@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Dec 16, 2010 at 08:56:06PM +0800, Wengang Wang wrote:
> In ocfs2_grab_pages_for_write() code, there is a comment that
> 
> 1131                 if (index == target_index && mmap_page) {
> 1132                         /*
> 1133                          * ocfs2_pagemkwrite() is a little different
> 1134                          * and wants us to directly use the page
> 1135                          * passed in.
> 1136                          */
> 1137                         lock_page(mmap_page);
> 
> I guess it's commented by you? So how it "wants" us to use the page
> passed in?
> The main purpose of page_mkwrite() is to setup the mapping of page index to
> sector(block) numbers on the device. I don't see using the page passed in is
> very important. Correct me if I am wrong.
> So also for (index == target_index && mmap_page) situation, we can use
> find_or_create_page() just like where it's used in other situation.
> find_lock_page() takes care of (page->mapping != mapping). How about it?

	Boy, this is a rabbit hole.  The return codes for page_mkwrite()
got changed a year ago, and no one updated ocfs2 (or ext4 or gfs2 for
that matter).  I've emailed Nick about it.

Joel

-- 

"Senator let's be sincere,
 As much as you can."

Joel Becker
Senior Development Manager
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
