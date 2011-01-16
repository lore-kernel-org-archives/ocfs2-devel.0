From: Jesper Juhl <jj@chaosbits.net>
Date: Mon, 17 Jan 2011 00:09:38 +0100 (CET)
Subject: [Ocfs2-devel] =?iso-8859-7?q?=5BPatch=5D_Kill_off_warning=3A_=A1i?=
	=?iso-8859-7?q?nline=A2_is_not_at_beginning_of_declaration?=
Message-ID: <alpine.LNX.2.00.1101170000270.13377@swampdragon.chaosbits.net>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: alsa-devel@alsa-project.org, Mauro Carvalho Chehab <mchehab@redhat.com>, Takashi Iwai <tiwai@suse.de>, Frederic Weisbecker <fweisbec@gmail.com>, "Gustavo F. Padovan" <padovan@profusion.mobi>, Jaroslav Kysela <perex@perex.cz>, Jens Axboe <jens.axboe@oracle.com>, Stephen Hemminger <shemminger@vyatta.com>, Andi Kleen <ak@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, "Pekka Savola (ipv6)" <pekkas@netcore.fi>, x86@kernel.org, James Morris <jmorris@namei.org>, Ingo Molnar <mingo@redhat.com>, oprofile-list@lists.sf.net, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Mark Fasheh <mfasheh@suse.com>, Marcel Holtmann <marcel@holtmann.org>, "John W. Linville" <linville@tuxdriver.com>, David Teigland <teigland@redhat.com>, Joel Becker <jlbec@evilplan.org>, Thomas Gleixner <tglx@linutronix.de>, linux-edac@vger.kernel.org, trivial@kernel.org, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.or>

Fix a bunch of 
	warning: ?inline? is not at beginning of declaration
messages when building a 'make allyesconfig' kernel with -Wextra.

These warnings are trivial to kill, yet rather annoying when building with 
-Wextra.
The more we can cut down on pointless crap like this the better (IMHO).

A previous patch to do this for a 'allnoconfig' build has already been 
merged. This just takes the cleanup a little further.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 arch/x86/oprofile/op_model_p4.c |    2 +-
 drivers/bluetooth/btusb.c       |    4 ++--
 drivers/cpuidle/sysfs.c         |    2 +-
 drivers/edac/i7300_edac.c       |    2 +-
 fs/ocfs2/dir.c                  |    2 +-
 kernel/trace/ring_buffer.c      |    2 +-
 net/ipv6/inet6_hashtables.c     |    2 +-
 net/mac80211/tx.c               |    2 +-
 sound/pci/au88x0/au88x0.h       |    4 ++--
 sound/pci/au88x0/au88x0_core.c  |    4 ++--
 10 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/x86/oprofile/op_model_p4.c b/arch/x86/oprofile/op_model_p4.c
index 9fadec0..98ab130 100644
--- a/arch/x86/oprofile/op_model_p4.c
+++ b/arch/x86/oprofile/op_model_p4.c
@@ -50,7 +50,7 @@ static inline void setup_num_counters(void)
 #endif
 }
 
-static int inline addr_increment(void)
+static inline int addr_increment(void)
 {
 #ifdef CONFIG_SMP
 	return smp_num_siblings == 2 ? 2 : 1;
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 1da773f..92d29bf 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -424,7 +424,7 @@ static void btusb_isoc_complete(struct urb *urb)
 	}
 }
 
-static void inline __fill_isoc_descriptor(struct urb *urb, int len, int mtu)
+static inline void __fill_isoc_descriptor(struct urb *urb, int len, int mtu)
 {
 	int i, offset = 0;
 
@@ -775,7 +775,7 @@ static void btusb_notify(struct hci_dev *hdev, unsigned int evt)
 	}
 }
 
-static int inline __set_isoc_interface(struct hci_dev *hdev, int altsetting)
+static inline int __set_isoc_interface(struct hci_dev *hdev, int altsetting)
 {
 	struct btusb_data *data = hdev->driver_data;
 	struct usb_interface *intf = data->isoc;
diff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c
index 0310ffa..be7917ec 100644
--- a/drivers/cpuidle/sysfs.c
+++ b/drivers/cpuidle/sysfs.c
@@ -300,7 +300,7 @@ static struct kobj_type ktype_state_cpuidle = {
 	.release = cpuidle_state_sysfs_release,
 };
 
-static void inline cpuidle_free_state_kobj(struct cpuidle_device *device, int i)
+static inline void cpuidle_free_state_kobj(struct cpuidle_device *device, int i)
 {
 	kobject_put(&device->kobjs[i]->kobj);
 	wait_for_completion(&device->kobjs[i]->kobj_unregister);
diff --git a/drivers/edac/i7300_edac.c b/drivers/edac/i7300_edac.c
index 05523b5..76d1f57 100644
--- a/drivers/edac/i7300_edac.c
+++ b/drivers/edac/i7300_edac.c
@@ -162,7 +162,7 @@ static struct edac_pci_ctl_info *i7300_pci;
 #define AMBPRESENT_0	0x64
 #define AMBPRESENT_1	0x66
 
-const static u16 mtr_regs[MAX_SLOTS] = {
+static const u16 mtr_regs[MAX_SLOTS] = {
 	0x80, 0x84, 0x88, 0x8c,
 	0x82, 0x86, 0x8a, 0x8e
 };
diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index d417b3f..f97b6f1 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -354,7 +354,7 @@ static inline int ocfs2_match(int len,
 /*
  * Returns 0 if not found, -1 on failure, and 1 on success
  */
-static int inline ocfs2_search_dirblock(struct buffer_head *bh,
+static inline int ocfs2_search_dirblock(struct buffer_head *bh,
 					struct inode *dir,
 					const char *name, int namelen,
 					unsigned long offset,
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index bd1c35a..6ee56b4 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -669,7 +669,7 @@ static struct list_head *rb_list_head(struct list_head *list)
  * the reader page). But if the next page is a header page,
  * its flags will be non zero.
  */
-static int inline
+static inline int
 rb_is_head_page(struct ring_buffer_per_cpu *cpu_buffer,
 		struct buffer_page *page, struct list_head *list)
 {
diff --git a/net/ipv6/inet6_hashtables.c b/net/ipv6/inet6_hashtables.c
index 633a6c2..b531972 100644
--- a/net/ipv6/inet6_hashtables.c
+++ b/net/ipv6/inet6_hashtables.c
@@ -124,7 +124,7 @@ out:
 }
 EXPORT_SYMBOL(__inet6_lookup_established);
 
-static int inline compute_score(struct sock *sk, struct net *net,
+static inline int compute_score(struct sock *sk, struct net *net,
 				const unsigned short hnum,
 				const struct in6_addr *daddr,
 				const int dif)
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 5950e3a..a449dd5 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -173,7 +173,7 @@ static __le16 ieee80211_duration(struct ieee80211_tx_data *tx, int group_addr,
 	return cpu_to_le16(dur);
 }
 
-static int inline is_ieee80211_device(struct ieee80211_local *local,
+static inline int is_ieee80211_device(struct ieee80211_local *local,
 				      struct net_device *dev)
 {
 	return local == wdev_priv(dev->ieee80211_ptr);
diff --git a/sound/pci/au88x0/au88x0.h b/sound/pci/au88x0/au88x0.h
index cf46bba..ecb8f4d 100644
--- a/sound/pci/au88x0/au88x0.h
+++ b/sound/pci/au88x0/au88x0.h
@@ -211,7 +211,7 @@ static void vortex_adbdma_startfifo(vortex_t * vortex, int adbdma);
 //static void vortex_adbdma_stopfifo(vortex_t *vortex, int adbdma);
 static void vortex_adbdma_pausefifo(vortex_t * vortex, int adbdma);
 static void vortex_adbdma_resumefifo(vortex_t * vortex, int adbdma);
-static int inline vortex_adbdma_getlinearpos(vortex_t * vortex, int adbdma);
+static inline int vortex_adbdma_getlinearpos(vortex_t * vortex, int adbdma);
 static void vortex_adbdma_resetup(vortex_t *vortex, int adbdma);
 
 #ifndef CHIP_AU8810
@@ -219,7 +219,7 @@ static void vortex_wtdma_startfifo(vortex_t * vortex, int wtdma);
 static void vortex_wtdma_stopfifo(vortex_t * vortex, int wtdma);
 static void vortex_wtdma_pausefifo(vortex_t * vortex, int wtdma);
 static void vortex_wtdma_resumefifo(vortex_t * vortex, int wtdma);
-static int inline vortex_wtdma_getlinearpos(vortex_t * vortex, int wtdma);
+static inline int vortex_wtdma_getlinearpos(vortex_t * vortex, int wtdma);
 #endif
 
 /* global stuff. */
diff --git a/sound/pci/au88x0/au88x0_core.c b/sound/pci/au88x0/au88x0_core.c
index 23f49f3..d43252a 100644
--- a/sound/pci/au88x0/au88x0_core.c
+++ b/sound/pci/au88x0/au88x0_core.c
@@ -1249,7 +1249,7 @@ static void vortex_adbdma_resetup(vortex_t *vortex, int adbdma) {
 	}
 }
 
-static int inline vortex_adbdma_getlinearpos(vortex_t * vortex, int adbdma)
+static inline int vortex_adbdma_getlinearpos(vortex_t * vortex, int adbdma)
 {
 	stream_t *dma = &vortex->dma_adb[adbdma];
 	int temp;
@@ -1498,7 +1498,7 @@ static int vortex_wtdma_getcursubuffer(vortex_t * vortex, int wtdma)
 		 POS_SHIFT) & POS_MASK);
 }
 #endif
-static int inline vortex_wtdma_getlinearpos(vortex_t * vortex, int wtdma)
+static inline int vortex_wtdma_getlinearpos(vortex_t * vortex, int wtdma)
 {
 	stream_t *dma = &vortex->dma_wt[wtdma];
 	int temp;



-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.
