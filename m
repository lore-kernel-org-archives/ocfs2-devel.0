From: Sunil Mushran <Sunil.Mushran@oracle.com>
Date: Tue Feb 17 16:58:56 2004
Subject: [Ocfs2-devel] Whats missing in mkfs?
In-Reply-To: <200402172220.i1HMKv24008615@penguin.co.intel.com>
References: <200402172220.i1HMKv24008615@penguin.co.intel.com>
Message-ID: <40329CAC.3090602@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

During the first mount we create the systemfiles. Ideally that should be
done during make. As we do this is on the first mount, we expect node 0
to be the first one to mount the volume and all other nodes are locked
out till the creation is not completed.

Follow code in mount where volhdr->internal_off and volhdr->root_off
is set to 0. When systemfiles/rootdirnode are created, these values are > 0.

Rusty Lynch wrote:

>The TODO list has an item about finishing mkfs.
>It looks like mkfs -t ocfs2 works fine.  Is there 
>something specific that is missing
>
>    --rusty
>_______________________________________________
>Ocfs2-devel mailing list
>Ocfs2-devel@oss.oracle.com
>http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>  
>
