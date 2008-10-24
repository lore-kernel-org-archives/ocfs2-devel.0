From: Tao Ma <tao.ma@oracle.com>
Date: Fri, 24 Oct 2008 09:28:00 +0800
Subject: [Ocfs2-devel] [PATCH 3/3] ocfs2/xattr: Proper hash collision
 handle in bucket division.v2
In-Reply-To: <20081024011451.GH12751@mail.oracle.com>
References: <1224218678-32196-3-git-send-email-tao.ma@oracle.com>
	<1224204876-26802-1-git-send-email-tao.ma@oracle.com>
	<20081023232030.GE12751@mail.oracle.com>
	<49011C51.1030806@oracle.com>
	<20081024011451.GH12751@mail.oracle.com>
Message-ID: <490124A0.1020407@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Joel Becker wrote:
> On Fri, Oct 24, 2008 at 08:52:33AM +0800, Tao Ma wrote:
>> Joel Becker wrote:
>>> 	Do we really need such a complex function?  Some of your
>>> bailouts don't even help much.  I *think* what you are doing here is
>>> trying to find the hash value change closest to the middle.
>>> Also, you don't need to pass around u16s.  It just makes the code
>>> more complex.
>>> 	What about:
>>>
>>> /* In an ocfs2_xattr_header, are the hashes of entries n and n+1 equal?. */
>>> static inline int xe_cmp(struct ocfs2_xattr_entry *entres, int n)
>>> {
>>> 	return le32_to_cpu(entries[n].xe_name_hash) ==
>>> 		le32_to_cpu(entries[n + 1].xe_name_hash);
>>> }
> 
> <snip>
> 
>> Don't agree. Actually in most cases we won't be so lucky to hit this  
>> situation(I run the test scripts many times and hit one), so I think  
>> most times we will just return "middle" and my function go out  
>> immediately, it is O(1). You function suppose that the hash collision  
>> happens frequently and iterate the half of the xh_entries so it is O(n).
> 
> 	Are you saying that you usually have only one xattr per bucket,
> even with many xattrs?  Because if we have n xattrs per bucket, your
> function will walk down from middle to 0 (half the bucket) unless n is
> 1.
No. See ocfs2_xattr_find_divide_pos.
+	/*
+	 * Find a xe before middle which doesn't have the same hash alue
+	 * with the previous one.
+	 */
+	pos = middle;
+	while (pos > 0) {
+		xe = &xh->xh_entries[pos];
+		xe_low = &xh->xh_entries[pos - 1];
+		if (le32_to_cpu(xe_low->xe_name_hash) !=
+		    le32_to_cpu(xe->xe_name_hash))
+			return pos;
+
+		pos--;
+	}
In most cases, it will return 'pos' immediately since the hash value 
isn't the same.

> 	Your function would be much more understandable even if it just
> used my xe_cmp() function.  Then some comment about what you are trying
> to achieve (I guessed at that), and perhaps a mention of the common
> case.
OK, I will add some comments for it. As for xe_cmp, can I use "cmp_xe" 
which already exists in xattr.c?

Regards,
Tao
