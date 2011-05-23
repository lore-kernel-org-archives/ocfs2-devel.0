From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon, 23 May 2011 16:55:11 -0700
Subject: [Ocfs2-devel] PATCH v3: Add support SEEK_DATA/HOLE in ocfs2
Message-ID: <1306194912-29893-1-git-send-email-sunil.mushran@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: josef@redhat.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, viro@ZenIV.linux.org.uko


The following patch implements SEEK_DATA/HOLE on ocfs2. The patch has
been tested atop Josef's v4 patch series.

Logs of successful runs on btrfs, ext3, ext4 and ocfs2 are available here:
http://oss.oracle.com/~smushran/seek_data/

Thanks
Sunil
