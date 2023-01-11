Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc244.phx1.oracleemaildelivery.com (aib29ajc244.phx1.oracleemaildelivery.com [192.29.103.244])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBC8BC5479D
	for <ocfs2-devel@archiver.kernel.org>; Wed, 11 Jan 2023 04:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ZKf5zsxSOTyeTVtf1YWoysgzL64BI3LwhWkOPJk9fFA=;
 b=pWM2G/Dcjr0fz3Tekuhw5ETcU+6r7IWnqUW7vIYqLhTmN0V1ETVERvfZ2ZlYvQyt7sChNHz5h4Bd
   SohKIbwv4r1AwPPMBGts29aYpb0MJwFAhdwKrx65ULzzmLcsgMuD0iGb/08P3vMs12RWD6BT1Nf1
   YakIHwCBEQGp/i3MVa0OU87UUUqNTDJJ7gnh1C4hOefdg0ZXAzbK7wvPLTIA8Ua/5REDajhIcqIQ
   X3omsHQTHIp1xmImsCHFnX5QjullNysnn4QefN+aRzvuMZRUXl8VUeHV8J7CwffErvQDpR/nkibY
   O/mAHDzcE4AbBUU5e24Hb9vk90r1QysMx6/jVA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=ZKf5zsxSOTyeTVtf1YWoysgzL64BI3LwhWkOPJk9fFA=;
 b=ZjqZnsXVjcgcYMAFczjgtKqGg5YeJXKD1PIGtBISCr8YhZXIxv7d3OGDfMa+InppXH+kQjUG+YCV
   4V+hIsfTWOJGIsEdZ0R1JDHj1JEKOyRstSllY9b+Me7iFmsUCMlIjTUK0S66IFO2YdeH31wWv4y/
   cSl9pFCJ5wrU7It8rwu8yHY9UH6Nx9PTPxqCn6LWBK+MvZyDfmXDTOXoFVXoX3HlOEQ7+OH4VmJt
   Z7QNMIqxbF+abgW5bgerjLMxpamE2hq9/PGY9UDqsRimyxHZ4IrAy3IF+D8w+iVvEyPrQsfpgjph
   0lr6vIXIkI7DZzJY+i0DS/YNJwBicwgKWyJm7A==
Received: by omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20221212 64bit (built Dec 12
 2022))
 with ESMTPS id <0ROB00MLW1UT7200@omta-ad1-fd1-101-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Wed, 11 Jan 2023 04:59:17 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
 MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=hwxTpnik4GFRaEfSysSXhVpKMkvUhYmc7DfBcKe47Q8=; b=gwuZnr26GfvdSwtTngWR0qosOP
 HUs1Cd/2fuK8Qmn4R+lCu65v90x3QDWE/O14fdzypvhBXSoYF4rbsU1ykCOH27b8Xj7rp2JRAnf60
 hcESkI65xxGkW5d1dmkrRhX253+s2bBeRS8x9As4FZk1sJg0/i9tdrxE2gBIqXrCUpjSjFVQmD59P
 yWkZ1kvppP2R3edwG0o19wXOgbKokc9xs+7pjD3M1PsiLmk0yVgIe/2Wh3vCPRj++UHnAGs2zyx+w
 F7rqLOZOjVvXeWfpNOgnCiEvEkTI822rlxKyO8e/cKnXhKVhmdqatpDQdhRiuxoCcE4feBhtRD5Bd
 BQG8ySuw==;
Date: Wed, 11 Jan 2023 04:58:43 +0000
To: Christoph Hellwig <hch@lst.de>
Message-id: <Y75CAwtM1gE1sevy@ZenIV>
References: <20230108165645.381077-1-hch@lst.de>
 <20230108165645.381077-4-hch@lst.de> <Y7sy5jzjT7tpPX6Z@casper.infradead.org>
 <20230110082225.GB11947@lst.de> <Y74c+WSEajAic3Kh@ZenIV>
 <20230111042641.GA15181@lst.de>
MIME-version: 1.0
Content-disposition: inline
In-reply-to: <20230111042641.GA15181@lst.de>
X-Source-IP: 62.89.141.173
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10586
 signatures=596816
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 impostorscore=0
 mlxscore=0 adultscore=0 bulkscore=0 clxscore=78 phishscore=0
 lowpriorityscore=0 priorityscore=290 spamscore=0 suspectscore=0 malwarescore=0
 mlxlogscore=698 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301110037
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net,
 Evgeniy Dushistov <dushistov@mail.ru>, Josef Bacik <josef@toxicpanda.com>,
 linux-mm@kvack.org, Chris Mason <clm@fb.com>, ocfs2-devel@oss.oracle.com,
 David Sterba <dsterba@suse.com>, linux-fsdevel@vger.kernel.org,
 linux-btrfs@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH 3/7] minix: don't flush page immediately for
 DIRSYNC directories
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.15
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/options/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel/>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
From: Al Viro via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Al Viro <viro@zeniv.linux.org.uk>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: zeniv.linux.org.uk
X-Proofpoint-SPF-Result: None
X-Spam: Clean
X-Proofpoint-ORIG-GUID: yNRCTjf-z737jqAC-dF-Br1GyUqHfBkl
X-Proofpoint-GUID: yNRCTjf-z737jqAC-dF-Br1GyUqHfBkl
Reporting-Meta:
 AAHBFCn8Q1ZnYSf0xAF8bbkkAJUjbtg/27BpzZwQHWNjit1lt3QUTWHIDGnVmq0p
 tQYKCbax+uMrxCryWxy6t4JmosiO4QG1xmx+4ICpJIz1oVVxR3yvIfZcTsqJeZm0
 IOrOsURFG5ORcbBJRXqkj+4Ar4cfcDeqxwHI6Ia218KeqNHwqVAF9ucMfWMeCZMU
 A2papoBUpcWmoTptigNnyYySQJ6AwLYqpzXvw73UObHQ3fc5CSowq+kSAd1ETMuA
 XPpaX23xqVdzfk5Dlb/qcda/6Pzhe/3QhfkZvGwqKTnmlkAM9v/+mDWv2gWtoD1t
 0gNDkBsoMU11CvedzbF3H4URi+xMbiPFCu9rp0CDniUMgfQXIwFarETQXRSdy3M5
 efo9/lOGKDDU2JyeRuG21ympNR9SR/lotbZ+t9iXO7hiJfb0LGcP8KuOgr6zt1xK
 zc0hpx8MpoQqUYRs4IBdkWbHBX35JoAKQOwirpXhXs41kczFB0JdbXSs1R/EwBzo
 xMQ8tBbwg5NGzje55G63PV6CVHzpwWap2emPacOsKGg=

On Wed, Jan 11, 2023 at 05:26:41AM +0100, Christoph Hellwig wrote:
> On Wed, Jan 11, 2023 at 02:20:41AM +0000, Al Viro wrote:
> > More seriously, all those ..._set_link() need to return an error and their
> > callers (..._rename()) need to deal with failures.
> 
> That's actually what I did yesterday:
> 
> http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/remove-write_one_page

ext2 also has that bug.  As well as "need to check for delete_entry errors"
one (also in ext2_rename()).

Completely untested patch follows:

diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index e5cbc27ba459..b38fab33cd0d 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -461,7 +461,7 @@ static int ext2_handle_dirsync(struct inode *dir)
 	return err;
 }
 
-void ext2_set_link(struct inode *dir, struct ext2_dir_entry_2 *de,
+int ext2_set_link(struct inode *dir, struct ext2_dir_entry_2 *de,
 		   struct page *page, void *page_addr, struct inode *inode,
 		   int update_times)
 {
@@ -480,7 +480,7 @@ void ext2_set_link(struct inode *dir, struct ext2_dir_entry_2 *de,
 		dir->i_mtime = dir->i_ctime = current_time(dir);
 	EXT2_I(dir)->i_flags &= ~EXT2_BTREE_FL;
 	mark_inode_dirty(dir);
-	ext2_handle_dirsync(dir);
+	return ext2_handle_dirsync(dir);
 }
 
 /*
diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index 28de11a22e5f..95c083bb1b7c 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -734,7 +734,7 @@ extern int ext2_delete_entry(struct ext2_dir_entry_2 *dir, struct page *page,
 			     char *kaddr);
 extern int ext2_empty_dir (struct inode *);
 extern struct ext2_dir_entry_2 *ext2_dotdot(struct inode *dir, struct page **p, void **pa);
-extern void ext2_set_link(struct inode *, struct ext2_dir_entry_2 *, struct page *, void *,
+extern int ext2_set_link(struct inode *, struct ext2_dir_entry_2 *, struct page *, void *,
 			  struct inode *, int);
 static inline void ext2_put_page(struct page *page, void *page_addr)
 {
diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index c056957221a2..5e3397680faa 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -370,8 +370,10 @@ static int ext2_rename (struct user_namespace * mnt_userns,
 			err = PTR_ERR(new_de);
 			goto out_dir;
 		}
-		ext2_set_link(new_dir, new_de, new_page, page_addr, old_inode, 1);
+		err = ext2_set_link(new_dir, new_de, new_page, page_addr, old_inode, 1);
 		ext2_put_page(new_page, page_addr);
+		if (err)
+			goto out_dir;
 		new_inode->i_ctime = current_time(new_inode);
 		if (dir_de)
 			drop_nlink(new_inode);
@@ -391,7 +393,9 @@ static int ext2_rename (struct user_namespace * mnt_userns,
 	old_inode->i_ctime = current_time(old_inode);
 	mark_inode_dirty(old_inode);
 
-	ext2_delete_entry(old_de, old_page, old_page_addr);
+	err = ext2_delete_entry(old_de, old_page, old_page_addr);
+	if (err)
+		goto out_dir;
 
 	if (dir_de) {
 		if (old_dir != new_dir)

_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
