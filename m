From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Mon Mar 15 15:55:03 2004
Subject: [Ocfs2-devel] [PATCH]2.6 mechanism for holding private inode data
In-Reply-To: <50D19C3AC815734C9E19FE4C4F6128A617804B@orsmsx403.jf.intel.com>
References: <50D19C3AC815734C9E19FE4C4F6128A617804B@orsmsx403.jf.intel.com>
Message-ID: <20040315215457.GC20057@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Mar 12, 2004 at 03:39:42PM -0800, Villalovos, John L wrote:
> Just curious on why you would ever want to use macros over inline
> functions?  I'll be honest and express my prejudice against macros right
> here and now :)  Since the compiler will convert an inline function into
> the exact same thing as a macro and you get type checking and
> predicatable behavior with a inline function.
Well, better a prejudice against macros, than a bias *towards* using them.
I've seen that before, and it ain't pretty :)
Mainly, for one liners which don't require typechecking, I find macros
easier to read -- there's less on the page there, especially when you've got
a bunch of said macros defined right after another -- compare Rusty's older
inode patch against the macro definitions we've got. Ok, maybe *those*
particular macros aren't the best example, but you get my point!  :)

Also, Manish tells me that using a macro in that case reduces gcc's working
set (though that's not really much of an issue).
	--Mark

--
Mark Fasheh
Software Developer, Oracle Corp
mark.fasheh@oracle.com
