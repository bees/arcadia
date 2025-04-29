<template>
  <DataTable
    v-model:expandedRows="expandedRows"
    :value="
      title_group.edition_groups.flatMap(
        (edition_group: EditionGroupHierarchyLite) => edition_group.torrents,
      )
    "
    rowGroupMode="subheader"
    :groupRowsBy="isGrouped ? 'edition_group_id' : undefined"
    sortMode="single"
    :sortField="sortBy == 'edition' ? '' : sortBy"
    :sortOrder="1"
    tableStyle="min-width: 50rem"
    size="small"
    :pt="{ rowGroupHeaderCell: { colspan: 8 } }"
  >
    <Column expander style="width: 1em" v-if="!preview" />
    <Column style="width: 1em" v-else />
    <Column :header="$t('torrent.properties')" style="min-width: 300px">
      <template #body="slotProps">
        <a
          :href="
            preview ? `/title-group/${title_group.id}?torrentId=${slotProps.data.id}` : undefined
          "
          @click="preview ? null : toggleRow(slotProps.data)"
          class="cursor-pointer"
        >
          <span v-if="slotProps.data.container && title_group.content_type != 'music'">{{
            slotProps.data.container
          }}</span>
          <span v-if="slotProps.data.video_codec"> / {{ slotProps.data.video_codec }}</span>
          <span v-if="slotProps.data.video_resolution">
            / {{ slotProps.data.video_resolution }}</span
          >
          <span v-if="slotProps.data.audio_codec">
            <span v-if="title_group.content_type != 'music'">/ </span
            >{{ slotProps.data.audio_codec }}</span
          >
          <span v-if="slotProps.data.audio_channels"> / {{ slotProps.data.audio_channels }}</span>
          <span v-if="slotProps.data.audio_bitrate_sampling">
            / {{ slotProps.data.audio_bitrate_sampling }}</span
          >
          <span
            v-if="
              slotProps.data.languages.length === 1 && slotProps.data.languages[0] !== 'English'
            "
          >
            / {{ slotProps.data.languages[0] }}
          </span>
          <span v-if="slotProps.data.languages.length > 1"> / Multi-Language </span>
          <span v-for="(feature, index) in slotProps.data.features" :key="index">
            / <span class="bold">{{ feature }}</span>
          </span>
          <span v-if="slotProps.data.release_group"> / {{ slotProps.data.release_group }}</span>
          <span v-if="slotProps.data.trumpable != ''">
            / <span class="warning">Trumpable</span>
          </span>
          <span v-if="slotProps.data.reports.length !== 0">
            / <span class="danger">Reported</span>
          </span>
        </a>
      </template>
    </Column>
    <Column :header="$t('general.uploaded')">
      <template #body="slotProps">
        {{ $timeAgo(slotProps.data.created_at) }}
      </template>
    </Column>
    <Column header="">
      <template #body="slotProps">
        <i
          v-tooltip.top="$t('torrent.download')"
          class="action pi pi-download"
          @click="downloadTorrent(slotProps.data.id)"
        />
        <i
          v-tooltip.top="$t('general.report')"
          class="action pi pi-flag"
          @click="reportTorrent(slotProps.data.id)"
        />
        <i v-tooltip.top="$t('torrent.copy_permalink')" class="action pi pi-link" />
        <i v-tooltip.top="$t('general.edit')" class="action pi pi-pen-to-square" />
      </template>
    </Column>
    <Column :header="$t('torrent.size')">
      <template #body="slotProps"> {{ $bytesToReadable(slotProps.data.size) }} </template>
    </Column>
    <!-- TODO: replace with real data from the tracker -->
    <Column style="width: 2.5em">
      <template #header>
        <i class="pi pi-replay" v-tooltip.top="$t('torrent.completed')" />
      </template>
      <template #body>10</template>
    </Column>
    <Column style="width: 2.5em">
      <template #header>
        <i class="pi pi-arrow-up" v-tooltip.top="$t('torrent.seeders')" />
      </template>
      <template #body><span style="color: green">5</span></template>
    </Column>
    <Column style="width: 2.5em">
      <template #header>
        <i class="pi pi-arrow-down" v-tooltip.top="$t('torrent.leechers')" />
      </template>
      <template #body>0</template>
    </Column>
    <template #groupheader="slotProps" v-if="isGrouped">
      <div class="edition-group-header">
        {{ getEditionGroupSlugForId(slotProps.data.edition_group_id) }}
      </div>
    </template>
    <template #expansion="slotProps" v-if="!preview">
      <div class="pre-style release-name">{{ slotProps.data.release_name }}</div>
      <Accordion :value="[]" multiple class="dense-accordion">
        <AccordionPanel value="0" v-if="slotProps.data.reports.length !== 0">
          <AccordionHeader>Report information</AccordionHeader>
          <AccordionContent>
            <div class="report" v-for="report in slotProps.data.reports" :key="report.id">
              <span class="bold">{{ $timeAgo(report.reported_at) }}</span
              >: {{ report.description }}
            </div>
          </AccordionContent>
        </AccordionPanel>
        <AccordionPanel value="1">
          <AccordionHeader>Mediainfo</AccordionHeader>
          <AccordionContent>
            <pre class="mediainfo">{{ purifyHtml(slotProps.data.mediainfo) }}</pre>
          </AccordionContent>
        </AccordionPanel>
        <AccordionPanel v-if="slotProps.data.description" value="2">
          <AccordionHeader>{{ $t('general.description') }}</AccordionHeader>
          <AccordionContent>
            <div>{{ slotProps.data.description }}</div>
          </AccordionContent>
        </AccordionPanel>
        <AccordionPanel v-if="slotProps.data.screenshots" value="3">
          <AccordionHeader>{{ $t('general.screenshots') }}</AccordionHeader>
          <AccordionContent>
            <div>{{ slotProps.data.screenshots }}</div>
          </AccordionContent>
        </AccordionPanel>
        <AccordionPanel value="4">
          <AccordionHeader>{{ $t('torrent.file_list') }}</AccordionHeader>
          <AccordionContent>
            <DataTable :value="slotProps.data.file_list.files" tableStyle="min-width: 50rem">
              <Column
                field="name"
                :header="(slotProps.data.file_list.parent_folder ?? '') + '/'"
              ></Column>
              <Column field="size" :header="$t('torrent.size')">
                <template #body="slotProps">
                  {{ $bytesToReadable(slotProps.data.size) }}
                </template>
              </Column>
            </DataTable>
          </AccordionContent>
        </AccordionPanel>
      </Accordion>
    </template>
  </DataTable>
  <Dialog
    closeOnEscape
    modal
    :header="$t('torrent.report_torrent')"
    v-model:visible="reportTorrentDialogVisible"
  >
    <ReportTorrentDialog :torrentId="reportingTorrentId" @reported="torrentReported" />
  </Dialog>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import DataTable from 'primevue/datatable'
import Column from 'primevue/column'
import DOMPurify from 'dompurify'
import Accordion from 'primevue/accordion'
import AccordionPanel from 'primevue/accordionpanel'
import AccordionHeader from 'primevue/accordionheader'
import AccordionContent from 'primevue/accordioncontent'
import ReportTorrentDialog from '../torrent/ReportTorrentDialog.vue'
import Dialog from 'primevue/dialog'
import {
  downloadTorrent,
  type EditionGroupHierarchyLite,
  type EditionGroupInfoLite,
  type TitleGroupAndAssociatedData,
  type Torrent,
  type TorrentHierarchyLite,
  type TorrentReport,
} from '@/services/api/torrentService'
import { useRoute } from 'vue-router'
import { getEditionGroupSlug } from '@/services/helpers'
import type { TitleGroupHierarchyLite } from '@/services/api/artistService'

interface Props {
  title_group: TitleGroupAndAssociatedData | TitleGroupHierarchyLite
  preview: boolean
  sortBy?: string
}
const { title_group, preview = false, sortBy = 'edition' } = defineProps<Props>()

const reportTorrentDialogVisible = ref(false)
const expandedRows = ref<TorrentHierarchyLite[]>([])
const reportingTorrentId = ref(0)
const route = useRoute()

const torrentReported = (torrentReport: TorrentReport) => {
  reportTorrentDialogVisible.value = false
  const reportedTorrent = title_group.edition_groups
    .flatMap((edition_group) => edition_group.torrents)
    .find((torrent: TorrentHierarchyLite) => torrent.id == torrentReport.reported_torrent_id)
  if (reportedTorrent) {
    if (reportedTorrent.reports) {
      reportedTorrent.reports.push(torrentReport)
    } else {
      reportedTorrent.reports = [torrentReport]
    }
  } else {
    console.error('torrent to report not found !')
  }
}
const reportTorrent = (id: number) => {
  reportingTorrentId.value = id
  reportTorrentDialogVisible.value = true
}
const toggleRow = (torrent: TorrentHierarchyLite) => {
  if (!expandedRows.value.some((expandedTorrent) => expandedTorrent.id === torrent.id)) {
    expandedRows.value = [...expandedRows.value, torrent]
  } else {
    expandedRows.value = expandedRows.value.filter((t) => t.id !== torrent.id)
  }
}

const getEditionGroupSlugForId = (edition_group_id: number) => {
  const editionGroup = title_group.edition_groups.find(
    (group: EditionGroupInfoLite) => group.id === edition_group_id,
  )
  if (editionGroup) {
    getEditionGroupSlug(editionGroup)
  }
}
const purifyHtml = (html: string) => {
  return DOMPurify.sanitize(html)
}
onMounted(() => {
  if (route.query.torrentId) {
    const torrent = title_group.edition_groups
      .flatMap((edition_group) => edition_group.torrents)
      .find((torrent) => torrent.id === parseInt(route.query.torrentId?.toString() ?? ''))

    if (torrent) {
      toggleRow(torrent)
    }
  }
})
const isGrouped = computed(() => sortBy === 'edition')
</script>
<style scoped>
.feature {
  font-weight: bold;
}

.action {
  margin-right: 7px;
  cursor: pointer;
}

.mediainfo {
  border: 2px dotted black;
  padding: 5px;
}

.edition-group-header {
  color: var(--color-primary);
}

.date {
  font-weight: bold;
}

.release-name {
  margin-bottom: 10px;
  margin-left: 7px;
}
</style>
