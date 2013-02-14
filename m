From: Joel Becker <jlbec@evilplan.org>
Date: Wed, 13 Feb 2013 18:11:25 -0800
Subject: [Ocfs2-devel] +
 ocfs2-remove-kfree-redundant-null-checks-fix.patch added to -mm tree
In-Reply-To: <20130213235509.1BEF331C1DB@corp2gmr1-1.hot.corp.google.com>
References: <20130213235509.1BEF331C1DB@corp2gmr1-1.hot.corp.google.com>
Message-ID: <20130214021123.GB18408@localhost>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Feb 13, 2013 at 03:55:08PM -0800, akpm at linux-foundation.org wrote:
> 
> The patch titled
>      Subject: ocfs2-remove-kfree-redundant-null-checks-fix
> has been added to the -mm tree.  Its filename is
>      ocfs2-remove-kfree-redundant-null-checks-fix.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
> 
> ------------------------------------------------------
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: ocfs2-remove-kfree-redundant-null-checks-fix
> 
> revert dubious change in ocfs2_begin_truncate_log_recovery()
> 
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Mark Fasheh <mfasheh@suse.com>
> Cc: Tim Gardner <tim.gardner@canonical.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

I think this is actually OK without the change.  The caller uses
*tl_copy, but it is always clear when returning -ative.  But if you want
to leave this patch in:

Acked-by: Joel Becker <jlbec@evilplan.org>

> ---
> 
>  fs/ocfs2/alloc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff -puN fs/ocfs2/alloc.c~ocfs2-remove-kfree-redundant-null-checks-fix fs/ocfs2/alloc.c
> --- a/fs/ocfs2/alloc.c~ocfs2-remove-kfree-redundant-null-checks-fix
> +++ a/fs/ocfs2/alloc.c
> @@ -6134,7 +6134,7 @@ bail:
>  		iput(tl_inode);
>  	brelse(tl_bh);
>  
> -	if (status < 0) {
> +	if (status < 0 && (*tl_copy)) {
>  		kfree(*tl_copy);
>  		*tl_copy = NULL;
>  		mlog_errno(status);
> _
> 
> Patches currently in -mm which might be from akpm at linux-foundation.org are
> 
> origin.patch
> linux-next.patch
> arch-alpha-kernel-systblss-remove-debug-check.patch
> bugh-prevent-double-evaulation-of-in-build_bug_on-fix.patch
> bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg-checkpatch-fixes.patch
> i-need-old-gcc.patch
> drivers-md-persistent-data-dm-transaction-managerc-rename-hash_size.patch
> goldfish-framebuffer-driver-fix.patch
> timer_list-convert-timer-list-to-be-a-proper-seq_file-fix.patch
> timer_list-convert-timer-list-to-be-a-proper-seq_file-v2-fix.patch
> timer_list-convert-timer-list-to-be-a-proper-seq_file-fix-fix.patch
> ocfs2-remove-kfree-redundant-null-checks-fix.patch
> sched-proc-sched_stat-fails-on-very-very-large-machines-fix.patch
> sched-proc-sched_stat-fails-on-very-very-large-machines-v2-fix.patch
> sched-proc-sched_stat-fails-on-very-very-large-machines-v2-fix-fix.patch
> sched-proc-sched_debug-fails-on-very-very-large-machines-fix.patch
> sched-proc-sched_debug-fails-on-very-very-large-machines-v2-fix.patch
> mm.patch
> mm-memcontrolc-convert-printkkern_foo-to-pr_foo.patch
> mm-hugetlbc-convert-to-pr_foo.patch
> cma-make-putback_lru_pages-call-conditional-fix.patch
> mm-vmscan-clean-up-get_scan_count-fix.patch
> mm-vmscan-compaction-works-against-zones-not-lruvecs-fix.patch
> mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
> mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
> mmotm-memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pagespatch-fix-fix.patch
> mm-make-madvisemadv_willneed-support-swap-file-prefetch-fix.patch
> mm-compaction-make-__compact_pgdat-and-compact_pgdat-return-void.patch
> mm-remove-flags-argument-to-mmap_region-fix.patch
> memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix.patch
> memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix-fix-fix.patch
> memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix.patch
> memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fix-fix-fix-fix.patch
> memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fix-fix-fix-fix-fix.patch
> memory-hotplug-remove-page-table-of-x86_64-architecture-fix.patch
> memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline-fix.patch
> memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline-fix-fix.patch
> cpu_hotplug-clear-apicid-to-node-when-the-cpu-is-hotremoved-fix.patch
> cpu-hotplugmemory-hotplug-clear-cpu_to_node-when-offlining-the-node-fix.patch
> page_alloc-add-movable_memmap-kernel-parameter-fix.patch
> page_alloc-add-movable_memmap-kernel-parameter-fix-fix-checkpatch-fixes.patch
> page_alloc-add-movable_memmap-kernel-parameter-fix-fix-fix.patch
> acpi-memory-hotplug-extend-movablemem_map-ranges-to-the-end-of-node-fix.patch
> acpi-memory-hotplug-support-getting-hotplug-info-from-srat-fix.patch
> acpi-memory-hotplug-support-getting-hotplug-info-from-srat-fix-fix.patch
> memory-failure-do-code-refactor-of-soft_offline_page.patch
> memory-failure-use-num_poisoned_pages-instead-of-mce_bad_pages-fix.patch
> mm-memory-failurec-fix-wrong-num_poisoned_pages-in-handling-memory-error-on-thp-fix.patch
> mm-dont-inline-page_mapping.patch
> swap-make-each-swap-partition-have-one-address_space-fix.patch
> page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fix.patch
> page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fix-fix.patch
> memcg-reduce-the-size-of-struct-memcg-244-fold-fix.patch
> memcg-reduce-the-size-of-struct-memcg-244-fold-fix-fix.patch
> memcg-fast-hierarchy-aware-child-test-fix.patch
> mm-rename-page-struct-field-helpers.patch
> mm-rename-page-struct-field-helpers-fix.patch
> mm-page_alloc-add-informative-debugging-message-in-page_outside_zone_boundaries-fix.patch
> include-linux-mmzoneh-cleanups.patch
> include-linux-mmzoneh-cleanups-fix.patch
> hwpoison-fix-misjudgement-of-page_action-for-errors-on-mlocked-pages-fix.patch
> mm-accurately-document-nr_free__pages-functions-with-code-comments-fix.patch
> drop_caches-add-some-documentation-and-info-messsge.patch
> memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
> scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
> kernel-smpc-cleanups.patch
> maintainers-remove-mark-m-hoffman-fix.patch
> backlight-add-lms501kf03-lcd-driver-fix.patch
> backlight-add-lms501kf03-lcd-driver-fix-fix.patch
> backlight-add-new-lp8788-backlight-driver-checkpatch-fixes.patch
> drivers-video-backlight-makefile-cleanup.patch
> checkpatch-dont-emit-the-camelcase-warning-for-pagefoo.patch
> binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
> rtc-ds1307-long-block-operations-bugfix-fix.patch
> rtc-max77686-add-maxim-77686-driver-fix.patch
> rtc-pcf8523-add-low-battery-voltage-support-fix.patch
> rtc-add-rtc-driver-for-tps80031-tps80032-v2-fix.patch
> rtc-add-support-for-spi-rtc-rx4581-checkpatch-fixes.patch
> hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
> signal-allow-to-send-any-siginfo-to-itself-fix.patch
> fs-proc-clean-up-printks.patch
> fs-proc-clean-up-printks-fix.patch
> fs-proc-clean-up-printks-fix-fix.patch
> fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix.patch
> fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix-fix.patch
> fs-seq_filec-seq_lseek-fix-switch-statement-indenting.patch
> fs-seq_filec-seq_lseek-fix-switch-statement-indenting-checkpatch-fixes.patch
> nfsd-idr_destroy-no-longer-needs-idr_remove_all.patch
> idr-remove-length-restriction-from-idr_layer-bitmap-checkpatch-fixes.patch
> drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix.patch
> dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
> aio-kiocb_cancel-fix.patch
> wait-add-wait_event_hrtimeout-fix.patch
> aio-use-cancellation-list-lazily-fix-fix.patch
> aio-give-shared-kioctx-fields-their-own-cachelines-fix.patch
> generic-dynamic-per-cpu-refcounting-fix.patch
> generic-dynamic-per-cpu-refcounting-sparse-fixes-fix.patch
> generic-dynamic-per-cpu-refcounting-doc-fix.patch
> aio-dont-include-aioh-in-schedh-fix.patch
> aio-dont-include-aioh-in-schedh-fix-fix.patch
> aio-dont-include-aioh-in-schedh-fix-3.patch
> aio-dont-include-aioh-in-schedh-fix-3-fix.patch
> aio-dont-include-aioh-in-schedh-fix-3-fix-fix.patch
> aio-kill-ki_retry-fix.patch
> block-aio-batch-completion-for-bios-kiocbs-fix.patch
> block-aio-batch-completion-for-bios-kiocbs-fix-fix.patch
> block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix.patch
> block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix.patch
> selftests-add-tests-for-efivarfs-fix.patch
> selftests-add-tests-for-efivarfs-fix-fix.patch
> tools-testing-selftests-makefile-rearrange-targets.patch
> selftests-add-a-simple-doc-fix.patch
> hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix.patch
> hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix.patch
> hlist-drop-the-node-parameter-from-iterators-checkpatch-fixes.patch
> hlist-drop-the-node-parameter-from-iterators-fix.patch
> hlist-drop-the-node-parameter-from-iterators-fix-fix.patch
> hlist-drop-the-node-parameter-from-iterators-fix-fix-fix.patch
> hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix-fix.patch
> debugging-keep-track-of-page-owners-fix-2-fix.patch
> journal_add_journal_head-debug.patch
> kernel-forkc-export-kernel_thread-to-modules.patch
> mutex-subsystem-synchro-test-module.patch
> slab-leaks3-default-y.patch
> put_bh-debug.patch
> 

-- 

"But all my words come back to me
 In shades of mediocrity.
 Like emptiness in harmony
 I need someone to comfort me."

			http://www.jlbec.org/
			jlbec at evilplan.org
